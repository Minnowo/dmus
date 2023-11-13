import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dmus/core/data/DataEntity.dart';

class MockSong extends Mock implements Song {}
class MockMetadata extends Mock implements Metadata {}
class MockFile extends Mock implements File {}

void main() {
  group('DataEntity Tests', () {
    test('Song creation', () {
      final song = Song(
        id: 1,
        title: 'Test Song',
        file: File('path/to/test.mp3'),
        metadata: MockMetadata(),
      );

      expect(song.id, 1);
      expect(song.title, 'Test Song');
      expect(song.file.path, 'path/to/test.mp3');
    });

    test('Playlist creation', () {
      final playlist = Playlist(id: 2, title: 'Test Playlist');

      expect(playlist.id, 2);
      expect(playlist.title, 'Test Playlist');
      expect(playlist.songs, isEmpty);
    });

    test('Album creation', () {
      final album = Album(id: 3, title: 'Test Album');

      expect(album.id, 3);
      expect(album.title, 'Test Album');
      expect(album.songs, isEmpty);
    });

    test('Playlist updateDuration', () {
      final song1 = Song(id: 1, title: 'Song 1', file: File('path/to/song1.mp3'), metadata: MockMetadata());
      final song2 = Song(id: 2, title: 'Song 2', file: File('path/to/song2.mp3'), metadata: MockMetadata());
      final playlist = Playlist.withSongs(id: 4, title: 'Test Playlist', songs: [song1, song2]);

      // Initial duration is the sum of song durations
      expect(playlist.duration, song1.duration + song2.duration);

      // Add a new song and update duration
      final song3 = Song(id: 3, title: 'Song 3', file: File('path/to/song3.mp3'), metadata: MockMetadata());
      playlist.songs.add(song3);
      playlist.updateDuration();

      expect(playlist.duration, song1.duration + song2.duration + song3.duration);
    });

  });
}
