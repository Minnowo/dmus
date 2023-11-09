


import 'package:dmus/core/localstorage/DatabaseController.dart';

final class TableLikes {

  final int songId;

  TableLikes.privateConstructor({required this.songId});

  static const String name = "tbl_likes";
  static const String songIdCol = "song_id";



  static Future<void> markSongLiked(int songId) async {

    final db = await DatabaseController.database;

    await db.rawInsert("INSERT OR IGNORE INTO $name ($songIdCol) VALUES (?)", [songId]);
  }

  static Future<void> markSongNotLiked(int songId) async {

    final db = await DatabaseController.database;

    await db.delete(name, where: "$songIdCol = ?", whereArgs: [songId]);
  }

  static Future<bool> isSongLiked(int songId) async {

    final db = await DatabaseController.database;

    return (await db.query(name, where: "$songIdCol = ?", whereArgs: [songId])).isNotEmpty;
  }
}