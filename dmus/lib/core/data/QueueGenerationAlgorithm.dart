import 'dart:math';

import 'DataEntity.dart';
import 'SmartQueueGenerationAlgorithm.dart';
import 'UIEnumSettings.dart';

/// Context passed to a [QueueGenerationAlgorithm] alongside the candidate pool
class QueueGenerationContext {
  /// Songs already present anywhere in the play queue (upcoming or already
  /// played) - a well-behaved algorithm should not add duplicates of these
  final List<Song> alreadyQueued;

  /// The song this fill is anchored to, if any (e.g. the song that was
  /// playing when an auto-fill was triggered, or the seed song for a
  /// "priority same artist" fill). Algorithms may use this for continuity
  /// (e.g. year smoothing) when [alreadyQueued] is empty
  final Song? contextSong;

  const QueueGenerationContext({this.alreadyQueued = const [], this.contextSong});
}

/// A pluggable strategy for picking/ordering songs when generating queue content
///
/// Implementations decide, given a pool of candidate songs, which and how many
/// of them (up to [n]) to hand back and in what order
abstract interface class QueueGenerationAlgorithm {
  Future<Iterable<Song>> selectSongs(List<Song> candidates, int n, QueueGenerationContext context);
}

/// Picks [n] songs from the candidates in a random order
///
/// This is the original (and still available) queue generation behaviour
final class RandomQueueGenerationAlgorithm implements QueueGenerationAlgorithm {
  const RandomQueueGenerationAlgorithm();

  @override
  Future<Iterable<Song>> selectSongs(List<Song> candidates, int n, QueueGenerationContext context) async {
    List<int> i = List.generate(candidates.length, (index) => index, growable: false)..shuffle();

    return i.sublist(0, min(n, candidates.length)).map((e) => candidates[e]);
  }
}

/// Returns the [QueueGenerationAlgorithm] implementation for the given [QueueAlgorithm]
QueueGenerationAlgorithm queueGenerationAlgorithmFor(QueueAlgorithm a) {
  switch (a) {
    case QueueAlgorithm.random:
      return const RandomQueueGenerationAlgorithm();
    case QueueAlgorithm.smart:
      return const SmartQueueGenerationAlgorithm();
  }
}
