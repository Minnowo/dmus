import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dmus/core/audio/QueueHistoryTracker.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/QueueGenerationAlgorithm.dart';
import 'package:dmus/core/data/SmartQueueGenerationAlgorithm.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSongStats.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../test_helpers.dart';

void main() {
  late Directory tempDir;
  const algorithm = SmartQueueGenerationAlgorithm();

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
    QueueHistoryTracker.instance.clearForTesting();
  });

  /// Inserts a real tbl_song row (so tbl_song_stats' FK is satisfiable) and
  /// returns a Song wired up with the given metadata/liked flag
  Future<Song> makeSong(
    String fileName, {
    String? artist,
    String? album,
    int? year,
    bool liked = false,
  }) async {
    final db = await DatabaseController.database;
    final id = await db.insert(TableSong.name, {TableSong.songPathCol: '${tempDir.path}/$fileName'});

    final file = File('${tempDir.path}/$fileName');

    final song = Song(
      id: id,
      title: fileName,
      file: file,
      metadata: AudioMetadata(
        file: file,
        artist: artist,
        album: album,
        year: year == null ? null : DateTime(year),
      ),
    );

    song.liked = liked;

    return song;
  }

  group('SmartQueueGenerationAlgorithm.selectSongs', () {
    test('excludes songs already in the queue', () async {
      final a = await makeSong('a.mp3');
      final b = await makeSong('b.mp3');
      final c = await makeSong('c.mp3');

      final result = await algorithm.selectSongs(
          [a, b, c], 2, QueueGenerationContext(alreadyQueued: [b]));

      expect(result.map((s) => s.id), isNot(contains(b.id)));
      expect(result.length, 2);
      expect(result.map((s) => s.id), containsAll([a.id, c.id]));
    });

    test('excludes songs played recently this session', () async {
      final a = await makeSong('a.mp3');
      final b = await makeSong('b.mp3');
      final c = await makeSong('c.mp3');

      QueueHistoryTracker.instance.recordPlayed(b);

      final result = await algorithm.selectSongs([a, b, c], 2, const QueueGenerationContext());

      expect(result.map((s) => s.id), isNot(contains(b.id)));
      expect(result.map((s) => s.id), containsAll([a.id, c.id]));
    });

    test('returns fewer than n songs when there are not enough eligible candidates', () async {
      final a = await makeSong('a.mp3');
      final b = await makeSong('b.mp3');

      final result = await algorithm.selectSongs([a, b], 5, const QueueGenerationContext());

      expect(result.length, 2);
    });

    test('returns an empty result for an empty candidate list', () async {
      final result = await algorithm.selectSongs([], 5, const QueueGenerationContext());

      expect(result, isEmpty);
    });

    test('never returns the same song twice', () async {
      final songs = await Future.wait(List.generate(10, (i) => makeSong('song$i.mp3')));

      final result = await algorithm.selectSongs(songs, 10, const QueueGenerationContext());

      expect(result.map((s) => s.id).toSet().length, result.length);
    });

    test('handles songs with entirely missing metadata without crashing', () async {
      final a = await makeSong('a.mp3');
      final b = await makeSong('b.mp3');

      final result = await algorithm.selectSongs([a, b], 2, const QueueGenerationContext());

      expect(result.length, 2);
    });

    test('strongly prefers a liked, never-played song over a disliked, heavily-skipped one', () async {
      final good = await makeSong('good.mp3', liked: true);
      final bad = await makeSong('bad.mp3');

      final db = await DatabaseController.database;
      for (var i = 0; i < 10; i++) {
        await TableSongStats.recordPlayStarted(db, bad.id);
        await TableSongStats.recordSkipped(db, bad.id);
      }

      var goodPicked = 0;
      const trials = 100;

      for (var i = 0; i < trials; i++) {
        final result = await algorithm.selectSongs([good, bad], 1, const QueueGenerationContext());
        if (result.first.id == good.id) goodPicked++;
      }

      expect(goodPicked, greaterThan(trials * 0.7));
    });

    test('penalizes a song repeatedly removed from the queue even though it has never actually played', () async {
      final untouched = await makeSong('untouched.mp3');
      final repeatedlyRemoved = await makeSong('removed.mp3');

      final db = await DatabaseController.database;
      for (var i = 0; i < 5; i++) {
        await TableSongStats.recordSkipped(db, repeatedlyRemoved.id);
      }

      final statsBefore = await TableSongStats.selectStatsForSongId(db, repeatedlyRemoved.id);
      expect(statsBefore!.playCount, 0);
      expect(statsBefore.skipCount, 5);

      var untouchedPicked = 0;
      const trials = 100;

      for (var i = 0; i < trials; i++) {
        final result =
            await algorithm.selectSongs([untouched, repeatedlyRemoved], 1, const QueueGenerationContext());
        if (result.first.id == untouched.id) untouchedPicked++;
      }

      expect(untouchedPicked, greaterThan(trials * 0.7));
    });

    test('prefers a song from the same year as the anchor over a very different year', () async {
      final anchor = await makeSong('anchor.mp3', year: 2000);
      final sameYear = await makeSong('same.mp3', year: 2000);
      final farYear = await makeSong('far.mp3', year: 1960);

      var sameYearPicked = 0;
      const trials = 100;

      for (var i = 0; i < trials; i++) {
        final result = await algorithm.selectSongs(
            [sameYear, farYear], 1, QueueGenerationContext(contextSong: anchor));
        if (result.first.id == sameYear.id) sameYearPicked++;
      }

      expect(sameYearPicked, greaterThan(trials * 0.6));
    });

    test('avoids repeating the artist of the song it just picked, given an alternative', () async {
      final artistA1 = await makeSong('a1.mp3', artist: 'Artist A');
      final artistA2 = await makeSong('a2.mp3', artist: 'Artist A');
      final artistB = await makeSong('b.mp3', artist: 'Artist B');

      // Across many independent fills, once one Artist A song is picked
      // first the recent-artist penalty should make the second pick favor
      // Artist B over the other Artist A song far more often than not -
      // asserted statistically since the first pick (before any recency
      // penalty applies) is an unbiased 3-way random choice
      var bothSameArtist = 0;
      const trials = 100;

      for (var i = 0; i < trials; i++) {
        final result =
            await algorithm.selectSongs([artistA1, artistA2, artistB], 2, const QueueGenerationContext());

        if (!result.map((s) => s.id).contains(artistB.id)) {
          bothSameArtist++;
        }
      }

      expect(bothSameArtist, lessThan(trials * 0.2));
    });
  });
}
