


import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

final class TablePlaylist {

  final int id;
  final String title;

  TablePlaylist.privateConstructor({required this.id, required this.title});

  static const String name = "tbl_playlist";
  static const String idCol = "id";
  static const String titleCol = "title";

  static Future<int?> insertPlaylist(String title) async {

    if(title.isEmpty) {
      logging.warning("Cannot insert playlist with title $title because it is empty");
      return null;
    }

    logging.finest("Inserting new playlist with title $title into the $name table");

    var db = await DatabaseController.instance.database;

    try {

      return await db.insert(
          name,
          {
            titleCol: title
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

  static Future<List<TablePlaylist>> selectAll() async {

    logging.finest("Selecting all songs from the $name table");

    var db = await DatabaseController.instance.database;

    var result = await db.query( name );

    return  result.map((e) => TablePlaylist.privateConstructor(id: e[idCol] as int, title: e[titleCol] as String )).toList();
  }

  static Future<TablePlaylist?> selectPlaylist(String title) async {

    logging.finest("Selecting $title from the $name table");

    var db = await DatabaseController.instance.database;

    var result = (await db.query(
        name,
        where: "$titleCol = ?",
        whereArgs: [title]
    )).firstOrNull;

    if(result == null) {
      return null;
    }

    return TablePlaylist.privateConstructor(id: result[idCol] as int, title: result[titleCol] as String );
  }
}