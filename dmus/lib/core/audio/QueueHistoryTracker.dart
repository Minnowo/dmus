import 'dart:collection';

import '../data/DataEntity.dart';

/// Tracks recently-played artists/albums/songs for the current app session only
///
/// Used by the "smart" queue algorithm to avoid repeats. Intentionally
/// in-memory and session-scoped rather than persisted: it resets on app
/// restart, since "recently played" for shuffling purposes is meant to
/// reflect what's freshly been heard in this listening session, not the
/// user's entire playback history
final class QueueHistoryTracker {
  QueueHistoryTracker._();

  static final QueueHistoryTracker instance = QueueHistoryTracker._();

  static const int maxRecentArtists = 8;
  static const int maxRecentAlbums = 5;
  static const int maxRecentSongs = 100;

  final Queue<String> _recentArtists = Queue();
  final Queue<String> _recentAlbums = Queue();
  final Queue<int> _recentSongIds = Queue();

  /// Recently-played artists, most recent first
  List<String> get recentArtists => List.unmodifiable(_recentArtists);

  /// Recently-played albums, most recent first
  List<String> get recentAlbums => List.unmodifiable(_recentAlbums);

  /// Ids of recently played songs
  Set<int> get recentSongIds => Set.unmodifiable(_recentSongIds);

  /// Records that [song] has started playing
  ///
  /// Songs with no artist/album tag do not pollute the artist/album windows -
  /// otherwise every untagged song would look like the same "artist"
  void recordPlayed(Song song) {
    final artist = song.metadata.artist;
    final album = song.metadata.album;

    if (artist != null && artist.isNotEmpty) {
      _pushFront(_recentArtists, artist, maxRecentArtists);
    }

    if (album != null && album.isNotEmpty) {
      _pushFront(_recentAlbums, album, maxRecentAlbums);
    }

    _pushFront(_recentSongIds, song.id, maxRecentSongs);
  }

  void _pushFront<T>(Queue<T> queue, T value, int maxSize) {
    queue.remove(value);
    queue.addFirst(value);

    while (queue.length > maxSize) {
      queue.removeLast();
    }
  }

  /// Clears all tracked history
  void clearForTesting() {
    _recentArtists.clear();
    _recentAlbums.clear();
    _recentSongIds.clear();
  }
}
