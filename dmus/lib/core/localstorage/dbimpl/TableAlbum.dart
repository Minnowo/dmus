
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import 'TableFMetadata.dart';



/// Represents tbl_album in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableAlbum {

  final int id;
  final String title;

  TableAlbum.privateConstructor({required this.id, required this.title});

  static const String name = "tbl_album";
  static const String idCol = "id";
  static const String titleCol = "title";


  /// Inserts a new playlist into the database
  ///
  /// Assumes all the songs exist in the database
  ///
  /// Returns null if the title is empty
  ///
  /// Returns the playlistId of the inserted playlist
  ///
  /// Throws DatabaseException
  static Future<int?> insertAlbum(String title, List<Song> songs) async {

    if(title.isEmpty) {
      logging.warning("Cannot insert playlist with title $title because it is empty");
      return null;
    }

    logging.finest("Creating playlist with title: $title and songs $songs");

    final db = await DatabaseController.database;

    final playlistId = await db.insert(name, { titleCol: title });

    TableAlbumSong.setSongsInAlbum(playlistId, songs);

    return playlistId;
  }



  /// Gets a Iterable<Song> for all the songs of the given playlistId
  ///
  /// Throws DatabaseException
  static Future<Iterable<Song>> selectAlbumSongs(int albumId) async {

    final db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TableAlbumSong.name}"
        " JOIN ${TableSong.name} ON ${TableAlbumSong.name}.${TableAlbumSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TableAlbumSong.name}.${TableAlbumSong.albumIdCol} = ?"
        " ORDER BY ${TableAlbumSong.songIndexCol}"
    ;

    final result = await db.rawQuery(sql, [albumId]);

    return result.map((e) => TableSong.fromMappedObjects(e));
  }


  /// Gets all playlists from the database
  ///
  /// Throws DatabaseException
  static Future<List<Album>> selectAll() async {

    var db = await DatabaseController.database;

    var albumResults = await db.query(TableAlbum.name);

    List<Album> albums = [];

    for(var e in albumResults) {

      int id = e[TableAlbum.idCol] as int;

      Album p = Album(id: id, title: e[TableAlbum.titleCol] as String);

      p.songs.addAll(await selectAlbumSongs(id));

      p.updateDuration();

      albums.add(p);
    }

    return albums;
  }

}