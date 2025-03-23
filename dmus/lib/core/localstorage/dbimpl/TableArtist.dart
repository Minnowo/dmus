
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableArtistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import '../../data/MyDataEntityCache.dart';
import 'TableFMetadata.dart';



/// Represents tbl_album in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableArtist {

  final int id;
  final String title;

  TableArtist.privateConstructor({required this.id, required this.title});

  static const String name = "tbl_artist";
  static const String idCol = "id";
  static const String titleCol = "title";



  /// Generate albums based off the metadata table and existing songs in the db
  static Future<void> generateArtists() async {

    logging.info("Generating Artist Information");

    final db = await DatabaseController.database;

    await db.delete(name);

    // insert albums into the albums table from the metadata table
    await db.rawQuery(
        "INSERT INTO $name ($titleCol) "
            "SELECT DISTINCT(${TableFMetadata.albumArtistCol}) FROM ${TableFMetadata
            .name} "
            "WHERE ${TableFMetadata.albumArtistCol} IS NOT NULL "
            "GROUP BY ${TableFMetadata.albumArtistCol} "
            "HAVING COUNT(${TableFMetadata.albumArtistCol}) >= 1;"
    );

    // inserts the songs into the album_songs table based on their album
    await db.rawQuery(
        "INSERT INTO ${TableArtistSong.name} (${TableArtistSong
            .artistIdCol}, ${TableArtistSong.songIdCol}, ${TableArtistSong
            .songIndexCol}, ${TableArtistSong.songAlbumCol}) "
            "SELECT "
            "a.${TableArtist.idCol}, "
            "f.${TableFMetadata.idCol}, "
            "f.${TableFMetadata.trackNumberCol}, "
            "f.${TableFMetadata.albumCol} "
            "FROM ${TableArtist.name} a "
            "JOIN ${TableFMetadata.name} f ON a.${TableArtist
            .titleCol} = f.${TableFMetadata.albumArtistCol} "
            // "WHERE f.${TableFMetadata.trackNumberCol} IS NOT NULL "
    );
  }

  static Future<int?> insertArist(String title, List<Song> songs) async {

    if(title.isEmpty) {
      return null;
    }

    final db = await DatabaseController.database;

    final playlistId = await db.insert(name, { titleCol: title });

    TableArtistSong.setSongsInArtist(playlistId, songs);

    return playlistId;
  }


  static Future<Iterable<Song>> selectArtistSongs(int artistId) async {

    final db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TableArtistSong.name}"
        " JOIN ${TableSong.name} ON ${TableArtistSong.name}.${TableArtistSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TableArtistSong.name}.${TableArtistSong.artistIdCol} = ?"
        " ORDER BY ${TableArtistSong.songAlbumCol}, ${TableArtistSong.songIndexCol}"
    ;

    final result = await db.rawQuery(sql, [artistId]);

    return await Future.wait(result.map((e) => TableSong.fromMappedObjects(e)));
  }

  static Future<List<Album>> selectAll() async {

    var db = await DatabaseController.database;

    var albumResults = await db.query(name);

    List<Album> albums = [];

    for(var e in albumResults) {

      int id = e[idCol] as int;

      Album p = Album(id: id, title: e[titleCol] as String);

      p.addSongs(await selectArtistSongs(id));

      await p.setPictureCacheKey(null);

      albums.add(p);
    }

    return albums;
  }

}
