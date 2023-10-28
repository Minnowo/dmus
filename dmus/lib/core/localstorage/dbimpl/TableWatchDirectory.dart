


import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

final class TableWatchDirectory {

  final String directoryPath;
  final int checkInterval;
  final bool isRecursive;

  TableWatchDirectory.privateConstructor({required this.directoryPath, required this.checkInterval, required this.isRecursive});

  static const String name = "tbl_watch_directory";
  static const String directoryPathCol = "directory_path";
  static const String checkIntervalCol = "check_interval";
  static const String isRecursiveCol = "is_recursive";

  static Future<int?> insertDirectory(File path, int checkInterval, bool isRecursive) async {

    logging.finest("Inserting $path into the $name table");

    var db = await DatabaseController.instance.database;

    try {

      return await db.insert(
          name,
          {
            directoryPathCol: path.absolute.path,
            checkIntervalCol: checkInterval,
            isRecursiveCol: isRecursive.toString()
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


  static Future<int?> removeDirectory(File path) async {

    logging.finest("Removing $path from $name");

    var db = await DatabaseController.instance.database;

    return await db.delete(
        name,
        where: "$directoryPathCol = ?",
        whereArgs: [path.absolute.path]
    );
  }

  static Future<List<TableWatchDirectory>> selectAll() async {

    logging.finest("Selecting all songs from the $name table");

    var db = await DatabaseController.instance.database;

    var result = await db.query( name );

    return  result.map((e) =>
        TableWatchDirectory.privateConstructor(
            directoryPath: e[directoryPathCol] as String,
            checkInterval: e[checkIntervalCol] as int,
            isRecursive: bool.parse(e[isRecursiveCol] as String))
    ).toList();
  }

}
