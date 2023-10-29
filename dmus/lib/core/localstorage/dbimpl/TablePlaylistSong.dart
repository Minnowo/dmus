


import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../../data/DataEntity.dart';

final class TablePlaylistSong {

  final int playlistId;
  final int songId;

  TablePlaylistSong.privateConstructor({required this.playlistId, required this.songId});

  static const String name = "tbl_playlist_song";
  static const String playlistIdCol= "playlist_id";
  static const String songIdCol = "song_id";

  static Future<bool> addSongsToPlaylist(int playlistId, List<Song> songs) async {

    var db = await DatabaseController.instance.database;

    const String sql = "INSERT OR IGNORE INTO $name ($playlistIdCol, $songIdCol) VALUES (?, ?);";

    for(var song in songs) {

      await db.rawInsert(sql, [playlistId, song.id]);
    }

    return true;
  }
}
