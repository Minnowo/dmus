
import 'dart:io';
import 'dart:typed_data';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import '../../Util.dart';
import '../../data/DataEntity.dart';



/// Represents tbl_playlist_song in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableSong {

  final int id;
  final String songPath;

  TableSong.privateConstructor({required this.id, required this.songPath});

  static const String name = "tbl_song";
  static const String idCol = "id";
  static const String songPathCol = "song_path";


  /// Selects the songId from the given path
  ///
  /// Returns null if the path does not exist in the database
  ///
  /// Returns the songId
  ///
  /// Throws Database Exception
  static Future<int?> selectSongIdUnchecked(Database db, File path) async {

    var result = await db.query(name, columns: [idCol], where: "$songPathCol = ?", whereArgs: [path.absolute.path]);

    return (result.firstOrNull?[idCol]) as int?;
  }


  /// Inserts a song into the database
  ///
  /// Returns null if the file does not exist
  ///
  /// Returns the songId if added or already exists
  ///
  /// Throws Database Exception
  static Future<int?> insertSong(File path) async {

    // TODO: optimize this function to use 1 query

    if(!(await path.exists())) {
      logging.warning("Cannot insert song which does not exist");
      return null;
    }

    var db = await DatabaseController.database;

    var existingSongId = await selectSongIdUnchecked(db, path);

    if(existingSongId != null) {

      logging.info("Song with path $path already exists in the database, updating metadata");

      if(!(await TableFMetadata.updateSongMetadataUnchecked(db, existingSongId, path))) {
        logging.warning("Could not update the metadata for song with id $existingSongId");
      }

      return existingSongId;
    }


    var songId = await db.insert( name, { songPathCol : path.absolute.path } );

    if(!await TableFMetadata.insertSongMetadataUnchecked(db, songId, path)) {
      logging.warning("Could not insert the metadata for song with id $songId");
    }

    return songId;
  }


  /// Gets a Song from the songId, metadata and all
  ///
  /// Returns null
  ///
  /// Returns Song
  static Future<Song?> selectFromId(int songId) async {

    var db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TableSong.name}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TableSong.idCol} = ?"
    ;

    var result = (await db.rawQuery(sql, [songId])).firstOrNull;

    if(result == null) {
      return null;
    }

    return fromMappedObjects(result);
  }


  /// Gets all Song from the database, metadata and all
  ///
  /// Returns a list of Song objects
  static Future<List<Song>> selectAllWithMetadata() async {

    var db = await DatabaseController.database;

    const String sql = "SELECT * FROM ${TableSong.name}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
    ;

    var result = await db.rawQuery(sql);

    final results = result.map((e) => fromMappedObjects(e)) .toList();

    for(final Song i in results) {
      i.liked  = await TableLikes.isSongLiked(i.id);
    }
    return results;
  }


  /// Returns a song from a map of column names to their datatype
  ///
  /// Does not check for keys to exist, only use this if you know your map is good
  static Song fromMappedObjects(Map<String, Object?> e) {

    Metadata m = TableFMetadata.fromMap(e);

    String path = e[TableSong.songPathCol] as String;
    String title = Path.basename(path);
    int duration = 0;

    if(m.trackName != null) {
      title = m.trackName!;
    }

    if(m.trackDuration != null) {
      duration = m.trackDuration!;
    }

    int id = e[TableSong.idCol] as int;

    Song s = Song.withDuration(id: id, title: title, duration: Duration(milliseconds: duration), file: File(path), metadata: m);

    s.pictureCacheKey = e[TableFMetadata.artCacheKeyCol] as Uint8List?;

    return s;
  }

  /// Deletes a song with the given songId from the database.
  ///
  /// Returns true if the song is successfully deleted, false otherwise.
  static Future<bool> deleteSongById(int songId) async {

    var db = await DatabaseController.database;

    try {

      final rowsDeleted = await db.delete(
        name,
        where: "$idCol = ?",
        whereArgs: [songId],
      );

      logging.finest("Deleted $rowsDeleted rows");

      return rowsDeleted > 0;
    }
    on DatabaseException catch (e) {
      logging.warning("Error deleting song: $e");
      return false;
    }
  }
}