import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mockito/mockito.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/audio/ProviderData.dart';

class MockSong extends Mock implements Song {}

void main() {
  group('PlayerPosition', () {
    test('PlayerPosition instances instantiated is not null', () {
      const position1 = PlayerPosition(position: Duration(seconds: 10), duration: Duration(seconds: 30));

      expect(position1, isNotNull);
    });
  });

  group('PlayerStateExtended', () {
    test('Two PlayerStateExtended instances with the same values should be equal', () {
      final state1 = PlayerStateExtended(paused: false, playing: true, processingState: ProcessingState.idle);
      final state2 = PlayerStateExtended(paused: false, playing: true, processingState: ProcessingState.idle);

      expect(state1, equals(state2));
    });
  });

  group('PlayerSong', () {
    test('PlayerSong instance should not be null', () {
      final song1 = PlayerSong(
        song: MockSong(), playerState: PlayerStateExtended(paused: false, playing: true, processingState: ProcessingState.idle),
        duration: const Duration(seconds: 30), position: const Duration(seconds: 10), index: 1,
      );

      expect(song1, isNotNull);
    });
  });
}