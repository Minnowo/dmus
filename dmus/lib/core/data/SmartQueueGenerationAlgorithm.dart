import 'dart:collection';
import 'dart:math';

import 'package:dmus/core/audio/QueueHistoryTracker.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSongStats.dart';

import 'DataEntity.dart';
import 'QueueGenerationAlgorithm.dart';

/// V1 "smart" queue algorithm
///
/// For each queue position: excludes songs already queued or played
/// recently this session, scores the remaining candidates, then
/// weighted-randomly picks from the top scorers (rather than always taking
/// the single best) so the resulting queue isn't fully deterministic.
///
/// Scoring favors liked and rarely/never-played songs and continuity with
/// the previous pick's year/decade, and penalizes songs whose artist/album
/// was heard recently this session and songs that get skipped a lot.
/// Missing metadata (no year, no artist, no stats row, ...) simply drops
/// that term from the score rather than excluding the song or crashing
final class SmartQueueGenerationAlgorithm implements QueueGenerationAlgorithm {
  const SmartQueueGenerationAlgorithm();

  /// How many of the highest-scoring candidates to weighted-pick from for
  /// each position, so the queue isn't just "always the top song"
  static const int _topPoolSize = 20;

  static const int _artistWindowSize = QueueHistoryTracker.maxRecentArtists;
  static const int _albumWindowSize = QueueHistoryTracker.maxRecentAlbums;

  static const double _wLiked = 15;
  static const double _wRarePlayMax = 12;
  static const double _wYearSame = 10;
  static const double _wYearSameDecade = 5;
  static const double _wRecentArtistMax = 20;
  static const double _wRecentAlbumMax = 25;
  static const double _wSkipPenaltyMax = 15;
  static const double _wRandomJitter = 3;

  @override
  Future<Iterable<Song>> selectSongs(List<Song> candidates, int n, QueueGenerationContext context) async {
    if (candidates.isEmpty || n <= 0) return const [];

    final db = await DatabaseController.database;
    final stats = await TableSongStats.selectStatsForSongIds(db, candidates.map((s) => s.id).toList());

    final excludedIds = <int>{
      ...context.alreadyQueued.map((s) => s.id),
      ...QueueHistoryTracker.instance.recentSongIds,
    };

    // Local scratch copies - seeded from the session tracker but only
    // updated locally as this fill progresses. Queueing a song isn't the
    // same as it having been played, so we never write back to the
    // session-wide tracker from here; only actual playback does that
    final recentArtists = Queue<String>.of(QueueHistoryTracker.instance.recentArtists);
    final recentAlbums = Queue<String>.of(QueueHistoryTracker.instance.recentAlbums);

    Song? anchor = context.alreadyQueued.isNotEmpty ? context.alreadyQueued.last : context.contextSong;

    final pool = List<Song>.of(candidates);
    final result = <Song>[];
    final rng = Random();

    for (var i = 0; i < n; i++) {
      final available = pool.where((s) => !excludedIds.contains(s.id)).toList();

      if (available.isEmpty) break;

      final scored = available
          .map((s) => _ScoredSong(s, _score(s, stats[s.id], anchor, recentArtists, recentAlbums, rng)))
          .toList()
        ..sort((a, b) => b.score.compareTo(a.score));

      final picked = _weightedPick(scored.take(_topPoolSize).toList(), rng);

      result.add(picked);
      pool.remove(picked);
      excludedIds.add(picked.id);

      _pushRecent(recentArtists, picked.metadata.artist, _artistWindowSize);
      _pushRecent(recentAlbums, picked.metadata.album, _albumWindowSize);

      anchor = picked;
    }

    return result;
  }

  double _score(
    Song song,
    SongStats? stats,
    Song? anchor,
    Queue<String> recentArtists,
    Queue<String> recentAlbums,
    Random rng,
  ) {
    double score = 0;

    if (song.liked) {
      score += _wLiked;
    }

    final playCount = stats?.playCount ?? 0;

    // Highest bonus for never-played (playCount 0), tapering off as
    // playCount grows - never-played and rarely-played are the same curve
    score += _wRarePlayMax / (1 + playCount);

    final skipCount = stats?.skipCount ?? 0;

    // max(1, playCount) so a song that's been removed from the queue
    // repeatedly without ever actually playing (playCount 0) still gets
    // penalized, rather than skipping this term entirely
    if (skipCount > 0) {
      score -= _wSkipPenaltyMax * min(1.0, skipCount / max(1, playCount));
    }

    final anchorYear = anchor?.metadata.year?.year;
    final songYear = song.metadata.year?.year;

    if (anchorYear != null && anchorYear != 0 && songYear != null && songYear != 0) {
      final diff = (anchorYear - songYear).abs();

      if (diff == 0) {
        score += _wYearSame;
      } else if (diff <= 9) {
        score += _wYearSameDecade;
      }
    }

    score += _recencyPenalty(song.metadata.artist, recentArtists, _wRecentArtistMax);
    score += _recencyPenalty(song.metadata.album, recentAlbums, _wRecentAlbumMax);

    // Small jitter so identical scores don't always sort the same way
    score += rng.nextDouble() * _wRandomJitter * 2 - _wRandomJitter;

    return score;
  }

  /// Returns a negative penalty if [value] is present in [window], strongest
  /// for the most-recently-seen entry and tapering to ~0 at the far end of
  /// the window. Returns 0 for missing metadata rather than penalizing it
  double _recencyPenalty(String? value, Queue<String> window, double maxPenalty) {
    if (value == null || value.isEmpty || window.isEmpty) return 0;

    final index = window.toList().indexOf(value);

    if (index == -1) return 0;

    return -maxPenalty * (1 - index / window.length);
  }

  void _pushRecent(Queue<String> queue, String? value, int maxSize) {
    if (value == null || value.isEmpty) return;

    queue.remove(value);
    queue.addFirst(value);

    while (queue.length > maxSize) {
      queue.removeLast();
    }
  }

  Song _weightedPick(List<_ScoredSong> pool, Random rng) {
    if (pool.length == 1) return pool.first.song;

    final minScore = pool.map((e) => e.score).reduce(min);
    final weights = pool.map((e) => e.score - minScore + 1.0).toList();
    final total = weights.reduce((a, b) => a + b);

    double r = rng.nextDouble() * total;

    for (var i = 0; i < pool.length; i++) {
      r -= weights[i];
      if (r <= 0) return pool[i].song;
    }

    return pool.last.song;
  }
}

class _ScoredSong {
  final Song song;
  final double score;

  const _ScoredSong(this.song, this.score);
}
