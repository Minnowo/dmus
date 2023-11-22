


import 'package:dmus/core/data/MyDataEntityCache.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';

import '../../data/DataEntity.dart';

final class TableLikes {

  final int songId;

  TableLikes.privateConstructor({required this.songId});

  static const String name = "tbl_likes";
  static const String songIdCol = "song_id";


  static Future<void> reGenerateLikedPlaylist() async {

    final db = await DatabaseController.database;

    await db.delete(TablePlaylist.name, where: "${TablePlaylist.idCol} = ${TablePlaylist.likedPlaylistId}");

    await TablePlaylist.generateLikesPlaylist();

    final results = await db.query(name);

    await TablePlaylistSong.setSongsInPlaylistJustId(TablePlaylist.likedPlaylistId, results.map((e) => e[songIdCol] as int).toList());
  }

  static Future<void> markSongLiked(int songId) async {

    final db = await DatabaseController.database;

    await db.rawInsert("INSERT OR IGNORE INTO $name ($songIdCol) VALUES (?)", [songId]);

    await reGenerateLikedPlaylist();
  }

  static Future<void> markSongNotLiked(int songId) async {

    final db = await DatabaseController.database;

    await db.delete(name, where: "$songIdCol = ?", whereArgs: [songId]);

    await reGenerateLikedPlaylist();
  }

  static Future<bool> isSongLiked(int songId) async {

    final db = await DatabaseController.database;

    return (await db.query(name, where: "$songIdCol = ?", whereArgs: [songId])).isNotEmpty;
  }
}