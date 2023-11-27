
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';
import '../../data/MyDataEntityCache.dart';
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



  /// Generate albums based off the metadata table and existing songs in the db
  static Future<void> generateAlbums() async {

    final db = await DatabaseController.database;

    await db.delete(name);

    // insert albums into the albums table from the metadata table
    await db.rawQuery(
        "INSERT INTO $name ($titleCol) "
            "SELECT DISTINCT(${TableFMetadata.albumCol}) FROM ${TableFMetadata
            .name} "
            "WHERE ${TableFMetadata.albumCol} IS NOT NULL "
            "GROUP BY ${TableFMetadata.albumCol} "
            "HAVING COUNT(${TableFMetadata.albumCol}) > 1;"
    );

    // inserts the songs into the album_songs table based on their album
    await db.rawQuery(
        "INSERT INTO ${TableAlbumSong.name} (${TableAlbumSong
            .albumIdCol}, ${TableAlbumSong.songIdCol}, ${TableAlbumSong
            .songIndexCol}) "
            "SELECT "
            "a.${TableAlbum.idCol}, "
            "f.${TableFMetadata.idCol}, "
            "f.${TableFMetadata.trackNumberCol} "
            "FROM ${TableAlbum.name} a "
            "JOIN ${TableFMetadata.name} f ON a.${TableAlbum
            .titleCol} = f.${TableFMetadata.albumCol} "
            "WHERE f.${TableFMetadata.trackNumberCol} IS NOT NULL "
            "ORDER BY f.${TableFMetadata.trackNumberCol};"
    );
  }


  /// Finds albums which match the given text, this does not search for songs in the album
  static Future<List<Album>> albumsWhichMatch(List<String> text) async {

    if(text.isEmpty) {
      return [];
    }

    const whereQueryTbl = "LOWER(${TableAlbum.name}.${TableAlbum.titleCol}) LIKE '%' || LOWER(?) || '%'"
    ;

    final sqlWhere = text.map((e) => whereQueryTbl).join(" OR ");

    var db = await DatabaseController.database;

    String sql = "SELECT * FROM ${TableAlbum.name}"
        " WHERE $sqlWhere"
    ;

    var playlistsResult = await db.rawQuery(sql, text);

    List<Album> playlists = [];

    for(var e in playlistsResult) {

      int id = e[TableAlbum.idCol] as int;

      final _ = MyDataEntityCache.getFromCache(id);

      if(_ != null && _ is Album) {
        playlists.add(_);
        continue;
      }

      Album p = Album(id: id, title: e[TableAlbum.titleCol] as String);

      p.songs.addAll(await selectAlbumSongs(id));

      p.updateDuration();

      playlists.add(p);

      MyDataEntityCache.updateCache(p);
    }

    return playlists;
  }


  /// Returns all albums which contain the given songs
  static Future<List<Album>> albumsWithSongs(List<Song> songs) async {

    String sql = "SELECT ${TableAlbum.name}.${TableAlbum.idCol}, ${TableAlbum.name}.${TableAlbum.titleCol} FROM ${TableAlbumSong.name}"
        " JOIN ${TableAlbum.name} ON ${TableAlbumSong.name}.${TableAlbumSong.albumIdCol} = ${TableAlbum.name}.${TableAlbum.idCol}"
        " JOIN ${TableSong.name} ON ${TableAlbumSong.name}.${TableAlbumSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " WHERE ${TableAlbumSong.name}.${TableAlbumSong.songIdCol} IN (${songs.map((e) => "?").join(",")})"
    ;

    var db = await DatabaseController.database;

    var playlistsResult = await db.rawQuery(sql, songs.map((e) => e.id).toList());

    List<Album> playlists = [];
    Set<int> seenId = {};

    for(var e in playlistsResult) {

      int id = e[TableAlbum.idCol] as int;

      if(seenId.contains(id)) {
        continue;
      }

      seenId.add(id);

      final _ = MyDataEntityCache.getFromCache(id);

      if(_ != null && _ is Album) {
        playlists.add(_);
        continue;
      }

      Album p = Album(id: id, title: e[TableAlbum.titleCol] as String);

      p.songs.addAll(await selectAlbumSongs(id));

      p.updateDuration();

      playlists.add(p);

      MyDataEntityCache.updateCache(p);
    }

    return playlists;
  }

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
