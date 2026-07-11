import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSettings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  group('DatabaseController.database', () {
    test('returns the same instance on repeated access', () async {
      final first = await DatabaseController.database;
      final second = await DatabaseController.database;

      expect(second, same(first));
    });

    test('enables foreign key enforcement on open', () async {
      final db = await DatabaseController.database;

      final result = await db.rawQuery('PRAGMA foreign_keys');

      expect(result.single.values.first, 1);
    });

    test('transparently reopens with a fresh instance if the cached one was closed', () async {
      final first = await DatabaseController.database;
      await first.close();

      final second = await DatabaseController.database;

      expect(second, isNot(same(first)));
      expect(second.isOpen, isTrue);
    });

    test('reopening reloads TableBlacklist\'s cache via onOpen', () async {
      await TableBlacklist.addToBlacklist('/music/a.mp3');

      final db = await DatabaseController.database;
      await db.close();
      await DatabaseController.database;

      expect(TableBlacklist.isBlacklisted('/music/a.mp3'), isTrue);
    });
  });

  group('DatabaseController.backupDatabase', () {
    test('copies the database to the destination and returns true', () async {
      await TableSettings.persist('key', 'value');
      final destination = File('${tempDir.path}/backup.db');

      final result = await DatabaseController.backupDatabase(destination);

      expect(result, isTrue);
      expect(await destination.exists(), isTrue);
    });

    test('the database remains usable after a backup', () async {
      final destination = File('${tempDir.path}/backup2.db');

      await DatabaseController.backupDatabase(destination);
      await TableSettings.persist('key', 'value');

      expect(await TableSettings.selectAll(), {'key': 'value'});
    });

    test('returns false instead of throwing when the destination cannot be written', () async {
      final destination = File('${tempDir.path}/nonexistent_subdir/backup.db');

      final result = await DatabaseController.backupDatabase(destination);

      expect(result, isFalse);
    });
  });
}
