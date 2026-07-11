import 'dart:math';

import 'DataEntity.dart';
import 'UIEnumSettings.dart';

/// A pluggable strategy for picking/ordering songs when generating queue content
///
/// Implementations decide, given a pool of candidate songs, which and how many
/// of them (up to [n]) to hand back and in what order
abstract interface class QueueGenerationAlgorithm {
  Iterable<Song> selectSongs(List<Song> candidates, int n);
}

/// Picks [n] songs from the candidates in a random order
///
/// This is the original (and current default) queue generation behaviour
final class RandomQueueGenerationAlgorithm implements QueueGenerationAlgorithm {
  const RandomQueueGenerationAlgorithm();

  @override
  Iterable<Song> selectSongs(List<Song> candidates, int n) {
    List<int> i = List.generate(candidates.length, (index) => index, growable: false)..shuffle();

    return i.sublist(0, min(n, candidates.length)).map((e) => candidates[e]);
  }
}

/// Returns the [QueueGenerationAlgorithm] implementation for the given [QueueAlgorithm]
QueueGenerationAlgorithm queueGenerationAlgorithmFor(QueueAlgorithm a) {
  switch (a) {
    case QueueAlgorithm.random:
      return const RandomQueueGenerationAlgorithm();
  }
}
