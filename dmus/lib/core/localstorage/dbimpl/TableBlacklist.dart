import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:sqflite/sqflite.dart';

final class TableBlacklist {
  final String songPath;

  TableBlacklist._privateConstructor({required this.songPath});

  static const String name = "tbl_blacklist";
  static const String songPathCol = "song_path";

  static final Set<String> _cache = {};

  /// Load the blacklist into memory
  static Future<void> loadCache(Database db) async {
    final f = await db.query(name);

    _cache.clear();
    _cache.addAll(f.map((e) => e[songPathCol] as String));
  }

  ///  Gets the list of blacklisted file paths
  static List<String> selectAll() {
    return _cache.toList();
  }

  /// Returns true if the path is blacklisted, checks the db if not in the cache
  static bool isBlacklisted(String path) {
    return _cache.contains(path);
  }

  /// Returns true if the path is blacklisted, checks the db if not in the cache
  static Future<bool> isBlacklistedDBCheck(String path) async {
    if (_cache.contains(path)) {
      return true;
    }

    final db = await DatabaseController.database;

    final f = await db.query(name, where: "$songPathCol = ?", whereArgs: [path]);

    return f.isNotEmpty;
  }

  /// Removes the path from the blacklist
  static Future<void> removeFromBlacklist(String path) async {
    final db = await DatabaseController.database;

    _cache.remove(path);
    await db.delete(name, where: "$songPathCol= ?", whereArgs: [path]);
  }

  /// Adds the path to the blacklist
  static Future<void> addFileToBlacklist(File path) async {
    addToBlacklist(path.absolute.path);
  }

  static Future<void> addToBlacklist(String path) async {
    final db = await DatabaseController.database;

    _cache.add(path);
    await db.rawInsert("INSERT OR IGNORE INTO $name ($songPathCol) VALUES (?)", [path]);
  }
}
