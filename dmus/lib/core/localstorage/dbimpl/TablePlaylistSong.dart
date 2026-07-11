import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../../data/DataEntity.dart';

/// Represents tbl_playlist_song in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TablePlaylistSong {
  final int playlistId;
  final int songId;
  final int index;

  TablePlaylistSong.privateConstructor({required this.playlistId, required this.songId, required this.index});

  static const String name = "tbl_playlist_song";
  static const String playlistIdCol = "playlist_id";
  static const String songIdCol = "song_id";
  static const String songIndexCol = "song_index";

  /// Adds the given songs to the given playlist in the database from just the id
  ///
  /// Returns true always
  ///
  /// Throws DatabaseException
  static Future<bool> setSongsInPlaylistJustId(int playlistId, List<int> songs) async {
    var db = await DatabaseController.database;
    await db.transaction((txn) async {

      await txn.delete(
        name,
        where: '$playlistIdCol = ?',
        whereArgs: [playlistId],
      );

      const String sql = "INSERT OR IGNORE INTO $name ($playlistIdCol, $songIdCol, $songIndexCol) VALUES (?, ?, ?);";

      for (int i = 0; i < songs.length; i++) {
        await txn.rawInsert(sql, [playlistId, songs[i], i]);
      }
    });
    

    return true;
  }

  static Future<bool>setSongsInPlaylistJustIdTx(Transaction txn, int playlistId, List<int> songs) async {
    await txn.delete(
      name,
      where: '$playlistIdCol = ?',
      whereArgs: [playlistId],
    );

    const String sql = "INSERT OR IGNORE INTO $name ($playlistIdCol, $songIdCol, $songIndexCol) VALUES (?, ?, ?);";

    for (int i = 0; i < songs.length; i++) {
      await txn.rawInsert(sql, [playlistId, songs[i], i]);
    }

    return true;
  }

  /// Adds the given songs to the given playlist in the database
  ///
  /// Returns true always
  ///
  /// Throws DatabaseException
  static Future<bool> setSongsInPlaylist(int playlistId, List<Song> songs) async {
    return await setSongsInPlaylistJustId(playlistId, songs.map((e) => e.id).toList());
  }

  static Future<bool> setSongsInPlaylistTx(Transaction txn, int playlistId, List<Song> songs) async {
    return await setSongsInPlaylistJustIdTx(txn, playlistId, songs.map((e) => e.id).toList());
  }

  static Future<void> removeSongFromPlaylist(int playlistId, int songId) async {
    var db = await DatabaseController.database;

    await removeSongFromPlaylistTx(db, playlistId, songId);
  }

  static Future<void> removeSongFromPlaylistTx(DatabaseExecutor db, int playlistId, int songId) async {
    await db.delete(TablePlaylistSong.name,
        where: "${TablePlaylistSong.playlistIdCol} = ? AND ${TablePlaylistSong.songIdCol} = ?",
        whereArgs: [playlistId, songId]);
  }

  static Future<void> appendSongToPlaylist(int playlistId, int songId) async {
    var db = await DatabaseController.database;

    await db.transaction((txn) => appendSongToPlaylistTx(txn, playlistId, songId));
  }

  static Future<void> appendSongToPlaylistTx(DatabaseExecutor db, int playlistId, int songId) async {
    const sql =
        "SELECT song_index FROM ${TablePlaylistSong.name} WHERE ${TablePlaylistSong.playlistIdCol} = ? ORDER BY ${TablePlaylistSong.songIndexCol} DESC LIMIT 1";

    final lastIndex = await db.rawQuery(sql, [songId]);

    int index = 0;

    if (lastIndex.isNotEmpty) {
      index = lastIndex.first[songIndexCol] as int;
      index++;
      logging.finest("Previous index was $index");
    }

    await db.insert(name, {playlistIdCol: playlistId, songIdCol: songId, songIndexCol: index});
  }
}
