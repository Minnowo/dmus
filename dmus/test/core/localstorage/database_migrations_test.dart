import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseMigrations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../test_helpers.dart';

void main() {
  late Directory tempDir;
  var scratchDbCount = 0;

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  /// A fresh, isolated database for testing migrations directly, independent
  /// of DatabaseController's shared test db file. Each call gets its own
  /// uniquely-named file rather than reusing inMemoryDatabasePath (":memory:")
  /// - sqflite_common_ffi's isolate-based server doesn't give fully
  /// independent databases for repeated opens of that same sentinel path
  /// within one test file, so later tests were seeing earlier tests' tables.
  Future<Database> openScratchDb() {
    scratchDbCount++;
    return openDatabase('${tempDir.path}/migrations_scratch_$scratchDbCount.db');
  }

  Future<Set<String>> tableNames(Database db) async {
    final rows = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    return rows.map((e) => e['name'] as String).toSet();
  }

  const v1Tables = {
    DatabaseMigrations.TBL_SETTINGS,
    DatabaseMigrations.TBL_BLACKLISTS,
    DatabaseMigrations.TBL_LIKES,
    DatabaseMigrations.TBL_HISTORY,
    DatabaseMigrations.TBL_SONG,
    DatabaseMigrations.TBL_FMETADATA,
    DatabaseMigrations.TBL_ALBUM,
    DatabaseMigrations.TBL_PLAYLIST,
    DatabaseMigrations.TBL_WATCH_DIRECTORY,
    DatabaseMigrations.TBL_ALBUM_SONG,
    DatabaseMigrations.TBL_PLAYLIST_SONG,
  };

  const v2OnlyTables = {
    DatabaseMigrations.TBL_ARTIST,
    DatabaseMigrations.TBL_ARTIST_SONG,
  };

  const v3OnlyTables = {
    DatabaseMigrations.TBL_MUSICBRAINZ,
  };

  const v3FMetadataColumns = {'bpm', 'composer', 'isrc'};

  Future<Set<String>> columnNames(Database db, String table) async {
    final rows = await db.rawQuery("PRAGMA table_info($table)");
    return rows.map((e) => e['name'] as String).toSet();
  }

  group('DatabaseMigrations.runMigrations', () {
    test('migrating 0 -> 1 creates exactly the version 1 tables', () async {
      final db = await openScratchDb();

      await DatabaseMigrations.runMigrations(db, 0, 1);

      final tables = await tableNames(db);

      expect(tables.containsAll(v1Tables), isTrue);
      expect(tables.intersection(v2OnlyTables), isEmpty);
    });

    test('migrating 0 -> 2 creates every table, including version 2 additions', () async {
      final db = await openScratchDb();

      await DatabaseMigrations.runMigrations(db, 0, 2);

      final tables = await tableNames(db);

      expect(tables.containsAll(v1Tables), isTrue);
      expect(tables.containsAll(v2OnlyTables), isTrue);
    });

    test('migrating 1 -> 2 adds the version 2 tables without disturbing existing ones', () async {
      final db = await openScratchDb();
      await DatabaseMigrations.runMigrations(db, 0, 1);

      await db.insert(DatabaseMigrations.TBL_SETTINGS, {'settings_key': 'k', 'settings_value': 'v'});

      await DatabaseMigrations.runMigrations(db, 1, 2);

      final tables = await tableNames(db);
      expect(tables.containsAll(v2OnlyTables), isTrue);

      final settingsRows = await db.query(DatabaseMigrations.TBL_SETTINGS);
      expect(settingsRows, hasLength(1));
    });

    test('migrating 0 -> 3 creates every table, including version 3 additions', () async {
      final db = await openScratchDb();

      await DatabaseMigrations.runMigrations(db, 0, 3);

      final tables = await tableNames(db);

      expect(tables.containsAll(v1Tables), isTrue);
      expect(tables.containsAll(v2OnlyTables), isTrue);
      expect(tables.containsAll(v3OnlyTables), isTrue);

      final fmetadataColumns = await columnNames(db, DatabaseMigrations.TBL_FMETADATA);
      expect(fmetadataColumns.containsAll(v3FMetadataColumns), isTrue);
    });

    test('migrating 2 -> 3 adds the version 3 additions without disturbing existing ones', () async {
      final db = await openScratchDb();
      await DatabaseMigrations.runMigrations(db, 0, 2);

      await db.insert(DatabaseMigrations.TBL_SETTINGS, {'settings_key': 'k', 'settings_value': 'v'});

      await DatabaseMigrations.runMigrations(db, 2, 3);

      final tables = await tableNames(db);
      expect(tables.containsAll(v3OnlyTables), isTrue);

      final fmetadataColumns = await columnNames(db, DatabaseMigrations.TBL_FMETADATA);
      expect(fmetadataColumns.containsAll(v3FMetadataColumns), isTrue);

      final settingsRows = await db.query(DatabaseMigrations.TBL_SETTINGS);
      expect(settingsRows, hasLength(1));
    });

    test('throws when no migration exists for the requested version', () async {
      final db = await openScratchDb();

      await expectLater(() => DatabaseMigrations.runMigrations(db, 0, 99), throwsException);
    });
  });
}
