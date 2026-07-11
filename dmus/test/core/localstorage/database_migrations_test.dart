import 'package:dmus/core/localstorage/DatabaseMigrations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpDbTest();
  });

  /// A fresh, isolated in-memory database for testing migrations directly,
  /// independent of DatabaseController's shared test db file.
  Future<Database> openScratchDb() => openDatabase(inMemoryDatabasePath);

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

    test('throws when no migration exists for the requested version', () async {
      final db = await openScratchDb();

      await expectLater(() => DatabaseMigrations.runMigrations(db, 0, 99), throwsException);
    });
  });
}
