import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSongStats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_helpers.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  Future<int> insertBareSong(Database db, String fileName) {
    return db.insert(TableSong.name, {TableSong.songPathCol: '${tempDir.path}/$fileName'});
  }

  group('TableSongStats.recordPlayStarted', () {
    test('creates a row with playCount 1 and lastPlayedAt set for a song with no existing stats', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableSongStats.recordPlayStarted(db, songId);

      final stats = await TableSongStats.selectStatsForSongId(db, songId);

      expect(stats, isNotNull);
      expect(stats!.playCount, 1);
      expect(stats.skipCount, 0);
      expect(stats.lastPlayedAt, isNotNull);
    });

    test('increments playCount and refreshes lastPlayedAt on repeated calls', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableSongStats.recordPlayStarted(db, songId);
      await TableSongStats.recordPlayStarted(db, songId);
      await TableSongStats.recordPlayStarted(db, songId);

      final stats = await TableSongStats.selectStatsForSongId(db, songId);

      expect(stats!.playCount, 3);
    });
  });

  group('TableSongStats.recordSkipped', () {
    test('creates a row with skipCount 1 for a song with no existing stats', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableSongStats.recordSkipped(db, songId);

      final stats = await TableSongStats.selectStatsForSongId(db, songId);

      expect(stats, isNotNull);
      expect(stats!.playCount, 0);
      expect(stats.skipCount, 1);
      expect(stats.lastPlayedAt, isNull);
    });

    test('increments skipCount without disturbing playCount/lastPlayedAt', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableSongStats.recordPlayStarted(db, songId);
      final afterPlay = await TableSongStats.selectStatsForSongId(db, songId);

      await TableSongStats.recordSkipped(db, songId);
      final afterSkip = await TableSongStats.selectStatsForSongId(db, songId);

      expect(afterSkip!.playCount, 1);
      expect(afterSkip.skipCount, 1);
      expect(afterSkip.lastPlayedAt, afterPlay!.lastPlayedAt);
    });
  });

  group('TableSongStats.selectStatsForSongIds', () {
    test('returns stats keyed by songId only for songs with a row', () async {
      final db = await DatabaseController.database;
      final playedSong = await insertBareSong(db, 'a.mp3');
      final untouchedSong = await insertBareSong(db, 'b.mp3');

      await TableSongStats.recordPlayStarted(db, playedSong);

      final result = await TableSongStats.selectStatsForSongIds(db, [playedSong, untouchedSong]);

      expect(result.containsKey(playedSong), isTrue);
      expect(result.containsKey(untouchedSong), isFalse);
      expect(result[playedSong]!.playCount, 1);
    });

    test('returns an empty map for an empty id list', () async {
      final db = await DatabaseController.database;

      expect(await TableSongStats.selectStatsForSongIds(db, []), isEmpty);
    });
  });

  group('TableSongStats.selectStatsForSongId', () {
    test('returns null for a song that has never been played or skipped', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      expect(await TableSongStats.selectStatsForSongId(db, songId), isNull);
    });
  });
}
