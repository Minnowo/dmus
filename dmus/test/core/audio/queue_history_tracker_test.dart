import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dmus/core/audio/QueueHistoryTracker.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:flutter_test/flutter_test.dart';

Song _song(int id, {String? artist, String? album}) {
  final file = File('fake_$id.mp3');
  return Song(id: id, title: 'Song $id', file: file, metadata: AudioMetadata(file: file, artist: artist, album: album));
}

void main() {
  setUp(() {
    QueueHistoryTracker.instance.clearForTesting();
  });

  group('QueueHistoryTracker.recordPlayed', () {
    test('tracks the played song id', () {
      QueueHistoryTracker.instance.recordPlayed(_song(1));

      expect(QueueHistoryTracker.instance.recentSongIds, contains(1));
    });

    test('tracks artist and album, most recent first', () {
      QueueHistoryTracker.instance.recordPlayed(_song(1, artist: 'Artist A', album: 'Album A'));
      QueueHistoryTracker.instance.recordPlayed(_song(2, artist: 'Artist B', album: 'Album B'));

      expect(QueueHistoryTracker.instance.recentArtists, ['Artist B', 'Artist A']);
      expect(QueueHistoryTracker.instance.recentAlbums, ['Album B', 'Album A']);
    });

    test('does not add null/empty artist or album to the recency windows', () {
      QueueHistoryTracker.instance.recordPlayed(_song(1, artist: null, album: ''));

      expect(QueueHistoryTracker.instance.recentArtists, isEmpty);
      expect(QueueHistoryTracker.instance.recentAlbums, isEmpty);
      expect(QueueHistoryTracker.instance.recentSongIds, contains(1));
    });

    test('moves a repeated artist to the front instead of duplicating it', () {
      QueueHistoryTracker.instance.recordPlayed(_song(1, artist: 'Artist A'));
      QueueHistoryTracker.instance.recordPlayed(_song(2, artist: 'Artist B'));
      QueueHistoryTracker.instance.recordPlayed(_song(3, artist: 'Artist A'));

      expect(QueueHistoryTracker.instance.recentArtists, ['Artist A', 'Artist B']);
    });

    test('caps the artist window at maxRecentArtists', () {
      for (var i = 0; i < QueueHistoryTracker.maxRecentArtists + 3; i++) {
        QueueHistoryTracker.instance.recordPlayed(_song(i, artist: 'Artist $i'));
      }

      expect(QueueHistoryTracker.instance.recentArtists.length, QueueHistoryTracker.maxRecentArtists);
      expect(QueueHistoryTracker.instance.recentArtists.first, 'Artist ${QueueHistoryTracker.maxRecentArtists + 2}');
    });

    test('caps the song window at maxRecentSongs', () {
      for (var i = 0; i < QueueHistoryTracker.maxRecentSongs + 5; i++) {
        QueueHistoryTracker.instance.recordPlayed(_song(i));
      }

      expect(QueueHistoryTracker.instance.recentSongIds.length, QueueHistoryTracker.maxRecentSongs);
      expect(QueueHistoryTracker.instance.recentSongIds, isNot(contains(0)));
    });
  });

  group('QueueHistoryTracker.clearForTesting', () {
    test('resets all tracked windows', () {
      QueueHistoryTracker.instance.recordPlayed(_song(1, artist: 'Artist A', album: 'Album A'));

      QueueHistoryTracker.instance.clearForTesting();

      expect(QueueHistoryTracker.instance.recentArtists, isEmpty);
      expect(QueueHistoryTracker.instance.recentAlbums, isEmpty);
      expect(QueueHistoryTracker.instance.recentSongIds, isEmpty);
    });
  });
}
