
import 'package:dmus/core/localstorage/DatabaseController.dart';
import '../../data/DataEntity.dart';



/// Represents tbl_playlist_song in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TablePlaylistSong {

  final int playlistId;
  final int songId;

  TablePlaylistSong.privateConstructor({required this.playlistId, required this.songId});

  static const String name = "tbl_playlist_song";
  static const String playlistIdCol= "playlist_id";
  static const String songIdCol = "song_id";
  static const String songIndexCol = "song_index";



  /// Adds the given songs to the given playlist in the database
  ///
  /// Returns true always
  ///
  /// Throws DatabaseException
  static Future<bool> setSongsInPlaylist(int playlistId, List<Song> songs) async {

    var db = await DatabaseController.database;

    await db.delete(
      name,
      where: '$playlistIdCol = ?',
      whereArgs: [playlistId],
    );

    const String sql = "INSERT OR IGNORE INTO $name ($playlistIdCol, $songIdCol, $songIndexCol) VALUES (?, ?, ?);";

    for(int i = 0; i < songs.length; i++) {

      await db.rawInsert(sql, [playlistId, songs[i].id, i]);
    }

    return true;
  }
}
