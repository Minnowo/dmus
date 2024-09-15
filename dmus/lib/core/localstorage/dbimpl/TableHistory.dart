


import 'package:dmus/core/localstorage/DatabaseController.dart';

final class TableHistory {

  final int songId;
  final DateTime timestamp;

  TableHistory.privateConstructor({required this.songId, required this.timestamp});

  static const String name = "tbl_history";
  static const String songIdCol = "song_id";
  static const String watchedAtCol= "watched_at";


  // static Future<void> addToHistory(int songId) async {
  //
  //   final db = await DatabaseController.database;
  //
  //   await db.insert(name, {
  //     songIdCol: songId
  //   });
  // }
}