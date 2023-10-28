


import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

final class TableSong {

  final int id;
  final String songPath;

  TableSong.privateConstructor({required this.id, required this.songPath});

  static const String name = "tbl_song";
  static const String idCol = "id";
  static const String songPathCol = "song_path";

  static Future<int?> insertSong(File path) async {

    logging.finest("Inserting $path into the $name table");

    var db = await DatabaseController.instance.database;

    try {

      return await db.insert(
          name,
          {
            songPathCol : path.absolute.path
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

  static Future<List<TableSong>> selectAll() async {

    logging.finest("Selecting all songs from the $name table");

    var db = await DatabaseController.instance.database;

    var result = await db.query( name );

    return  result.map((e) => TableSong.privateConstructor(id: e[idCol] as int, songPath: e[songPathCol] as String )).toList();
  }

  static Future<TableSong> selectSong(File path) async {

    logging.finest("Selecting $path from the $name table");

    var db = await DatabaseController.instance.database;

    var result = (await db.query(
        name,
        where: "$songPathCol = ?",
        whereArgs: [path.absolute.path]
    )).first;

    return TableSong.privateConstructor(id: result[idCol] as int, songPath: result[songPathCol] as String );
  }
}