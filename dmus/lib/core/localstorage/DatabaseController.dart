import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseMigrations.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import '../Util.dart';

/// The Database Controller
///
/// Handles initializing the database and versioning
///
/// Used to get access to the database
final class DatabaseController {
  DatabaseController._privateConstructor();

  /// The database instance
  static Database? _database;

  /// The database version, used for migrations
  static const int VERSION = 2;

  /// If true, the database is deleted before firsts connecting
  ///
  /// If false, the database is opened as normal
  static const bool alwaysCreateDb = false;

  static const String databaseFilename = "client.db";

  /// database instance getter, initalizes the database on first call
  static Future<Database> get database async {
    if (_database != null && !_database!.isOpen) {
      _database = null;
    }

    _database ??= await _initDatabase();

    return _database!;
  }

  /// Initialized the database
  ///
  /// If the database exists, and alwaysCreateDb is true, the database is deleted
  static Future<Database> _initDatabase() async {
    logging.config("Database is being initialized");

    String databasePath = Path.join(await getDatabasesPath(), databaseFilename);

    logging.config("Database path is $databasePath");

    if (alwaysCreateDb && await File(databasePath).exists()) {
      logging.config("alwaysCreateDb is true, database is being deleted");

      await deleteDatabase(databasePath);
    }

    return await openDatabase(databasePath,
        version: VERSION, onOpen: _onOpen, onCreate: _createDatabase, onUpgrade: _onUpgrade);
  }

  /// Creates the database from the migration history
  static Future<void> _createDatabase(Database db, int version) async {
    logging.config("The database is being created");
    await DatabaseMigrations.runMigrations(db, 0, version);
  }

  /// Migrates the database from previous versions
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    logging.config("The database is being upgraded, starting from $oldVersion until $newVersion");
    await DatabaseMigrations.runMigrations(db, oldVersion, newVersion);
  }

  /// On open enable foreign keys
  static Future<void> _onOpen(Database db) async {
    await db.execute("PRAGMA foreign_keys = ON");
    await TableBlacklist.loadCache(db);
  }

  /// Copies the database to the given path
  static Future<bool> backupDatabase(File path) async {
    if (_database != null) {
      await _database!.close();
    }

    String databasePath = Path.join(await getDatabasesPath(), databaseFilename);

    File databaseFile = File(databasePath);

    try {
      await databaseFile.copy(path.path);
      return true;
    } catch (e) {
      logging.warning(e);
      return false;
    } finally {
      await database;
    }
  }
}
