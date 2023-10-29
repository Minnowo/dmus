

import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseMigrations.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import '../Util.dart';

class DatabaseController {

  static final DatabaseController instance = DatabaseController._privateConstructor();

  static Database? _database;

  static const int VERSION = 1;

  static const bool alwaysCreateDb =true;

  DatabaseController._privateConstructor();

  Future<Database> get database async {

    _database ??= await _initDatabase();

    return _database!;
  }


  Future<Database> _initDatabase() async {

    logging.config("Database is being initalized");

    String databasePath = Path.join(await getDatabasesPath(), 'client.db');

    logging.config("Database path is $databasePath");

    if (alwaysCreateDb && await File(databasePath).exists()) {

      logging.config("alwaysCreateDb is true, database is being deleted");

      await deleteDatabase(databasePath);
    }

    return await openDatabase(
      databasePath,
      version: VERSION,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await DatabaseMigrations.runMigrations(db, 0, version);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await DatabaseMigrations.runMigrations(db, oldVersion, newVersion);
  }
}