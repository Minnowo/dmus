import 'package:dmus/core/localstorage/DatabaseController.dart';

import '../../data/DataEntity.dart';

/// Represents tbl_album in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableAlbumSong {
  final int albumId;
  final int songId;
  final int index;

  TableAlbumSong.privateConstructor({required this.albumId, required this.songId, required this.index});

  static const String name = "tbl_album_song";
  static const String albumIdCol = "album_id";
  static const String songIdCol = "song_id";
  static const String songIndexCol = "song_index";

  /// Adds the given songs to the given playlist in the database
  ///
  /// Returns true always
  ///
  /// Throws DatabaseException
  static Future<bool> setSongsInAlbum(int playlistId, List<Song> songs) async {
    var db = await DatabaseController.database;

    await db.delete(
      name,
      where: '$albumIdCol = ?',
      whereArgs: [playlistId],
    );

    const String sql = "INSERT OR IGNORE INTO $name ($albumIdCol, $songIdCol, $songIndexCol) VALUES (?, ?, ?);";

    for (int i = 0; i < songs.length; i++) {
      await db.rawInsert(sql, [playlistId, songs[i].id, i]);
    }

    return true;
  }
}
