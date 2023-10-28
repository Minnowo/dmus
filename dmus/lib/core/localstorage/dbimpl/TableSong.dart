


import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

final class TableSong {

  final int id;
  final String song_path;

  TableSong.privateConstructor({required this.id, required this.song_path});

  static const String name = "tbl_song";
  static const String id_col = "id";
  static const String song_path_col = "song_path";

  static Future<int?> insertSong(File path) async {

    logging.finest("Inserting $path into the $name table");

    var db = await DatabaseController.instance.database;

    try {

      return await db.insert(
          name,
          {
            song_path_col : path.absolute.path
          }
      );
    }
    catch(e) {

      if(e is! DatabaseException) {
        rethrow;
      }
    }
    return null;
  }

  static Future<List<TableSong>> selectAllSongs() async {

    logging.finest("Selecting all songs from the $name table");

    var db = await DatabaseController.instance.database;

    var result = await db.query( name );

    return  result.map((e) => TableSong.privateConstructor(id: e[id_col] as int, song_path: e[song_path_col] as String )).toList();
  }

  static Future<TableSong> selectSong(File path) async {

    logging.finest("Selecting $path from the $name table");

    var db = await DatabaseController.instance.database;

    var result = (await db.query(
        name,
        where: "$song_path_col = ?",
        whereArgs: [path.absolute.path]
    )).first;

    return TableSong.privateConstructor(id: result[id_col] as int, song_path: result[song_path_col] as String );
  }
}