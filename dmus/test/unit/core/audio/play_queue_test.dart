import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/audio/PlayQueue.dart';

class MockSong extends Mock implements Song {}

void main() {
  group('PlayQueue Tests', () {
    late PlayQueue playQueue;

    setUp(() {
      playQueue = PlayQueue();
    });

    test('Initial state of PlayQueue', () {
      expect(playQueue.readQueue, isEmpty);
      expect(playQueue.current(), isNull);
      expect(playQueue.state, QueueState.empty);
      expect(playQueue.currentPosition, -1);
    });

    test('Adding a song to the queue', () {
      final song = MockSong();
      playQueue.addToQueue(song);

      expect(playQueue.readQueue, contains(song));
      expect(playQueue.current(), equals(song));
      expect(playQueue.state, QueueState.single);
      expect(playQueue.currentPosition, 0);
    });

    test('Advancing to the next song', () {
      final song1 = MockSong();
      final song2 = MockSong();
      playQueue.addToQueue(song1);
      playQueue.addToQueue(song2);

      final nextSong = playQueue.advanceNext();

      expect(nextSong, equals(song2));
      expect(playQueue.current(), equals(song2));
      expect(playQueue.state, QueueState.end);
      expect(playQueue.currentPosition, 1);
    });

  });
}
