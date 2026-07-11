import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers.dart';

void main() {
  setUpAll(() async {
    await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  group('TableBlacklist.addToBlacklist / isBlacklisted', () {
    test('a path is not blacklisted before being added', () {
      expect(TableBlacklist.isBlacklisted('/music/song.mp3'), isFalse);
    });

    test('adding a path blacklists it immediately (cache) and persists it', () async {
      await TableBlacklist.addToBlacklist('/music/song.mp3');

      expect(TableBlacklist.isBlacklisted('/music/song.mp3'), isTrue);
      expect(TableBlacklist.selectAll(), ['/music/song.mp3']);
    });

    test('adding the same path twice does not duplicate it', () async {
      await TableBlacklist.addToBlacklist('/music/song.mp3');
      await TableBlacklist.addToBlacklist('/music/song.mp3');

      expect(TableBlacklist.selectAll(), ['/music/song.mp3']);
    });
  });

  group('TableBlacklist.addFileToBlacklist', () {
    test('blacklists the absolute path of the given file', () async {
      final file = File('music/song.mp3');

      await TableBlacklist.addFileToBlacklist(file);

      expect(TableBlacklist.isBlacklisted(file.absolute.path), isTrue);
    });
  });

  group('TableBlacklist.isBlacklistedDBCheck', () {
    test('returns true from cache without touching the db', () async {
      await TableBlacklist.addToBlacklist('/music/song.mp3');

      expect(await TableBlacklist.isBlacklistedDBCheck('/music/song.mp3'), isTrue);
    });

    test('returns false for a path that was never blacklisted', () async {
      expect(await TableBlacklist.isBlacklistedDBCheck('/music/unknown.mp3'), isFalse);
    });

    test('falls back to the db when the path is not in the in-memory cache', () async {
      // Insert directly into the table, bypassing addToBlacklist's cache update,
      // to simulate a row that exists in the db but hasn't been loaded into cache yet.
      final db = await DatabaseController.database;
      await db.rawInsert('INSERT INTO ${TableBlacklist.name} (${TableBlacklist.songPathCol}) VALUES (?)',
          ['/music/dbonly.mp3']);

      expect(TableBlacklist.isBlacklisted('/music/dbonly.mp3'), isFalse);
      expect(await TableBlacklist.isBlacklistedDBCheck('/music/dbonly.mp3'), isTrue);
    });
  });

  group('TableBlacklist.removeFromBlacklist', () {
    test('un-blacklists a path from both the cache and the db', () async {
      await TableBlacklist.addToBlacklist('/music/song.mp3');

      await TableBlacklist.removeFromBlacklist('/music/song.mp3');

      expect(TableBlacklist.isBlacklisted('/music/song.mp3'), isFalse);
      expect(await TableBlacklist.isBlacklistedDBCheck('/music/song.mp3'), isFalse);
      expect(TableBlacklist.selectAll(), isEmpty);
    });

    test('removing a path that was never blacklisted is a no-op', () async {
      await TableBlacklist.removeFromBlacklist('/music/never-added.mp3');

      expect(TableBlacklist.selectAll(), isEmpty);
    });
  });

  group('TableBlacklist.loadCache', () {
    test('populates the cache from the db and replaces whatever was cached before', () async {
      await TableBlacklist.addToBlacklist('/music/stale.mp3');

      final db = await DatabaseController.database;
      await db.delete(TableBlacklist.name);
      await db.rawInsert(
          'INSERT INTO ${TableBlacklist.name} (${TableBlacklist.songPathCol}) VALUES (?)', ['/music/fresh.mp3']);

      await TableBlacklist.loadCache(db);

      expect(TableBlacklist.isBlacklisted('/music/stale.mp3'), isFalse);
      expect(TableBlacklist.isBlacklisted('/music/fresh.mp3'), isTrue);
    });
  });

  group('TableBlacklist.selectAll', () {
    test('returns an empty list when nothing is blacklisted', () {
      expect(TableBlacklist.selectAll(), isEmpty);
    });

    test('returns every blacklisted path', () async {
      await TableBlacklist.addToBlacklist('/music/a.mp3');
      await TableBlacklist.addToBlacklist('/music/b.mp3');

      expect(TableBlacklist.selectAll(), containsAll(['/music/a.mp3', '/music/b.mp3']));
    });
  });
}
