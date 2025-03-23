import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';

import '../../localstorage/ImportController.dart';
import '../../localstorage/dbimpl/TableLikes.dart';
import '../../localstorage/dbimpl/TablePlaylist.dart';
import '../DataEntity.dart';

class PlaylistProvider extends ChangeNotifier {
  late final List<StreamSubscription> _subscriptions;

  final List<Playlist> playlists = [];

  PlaylistProvider() {
    _subscriptions = [
      ImportController.onPlaylistCreated.listen(addPlaylist),
      ImportController.onPlaylistUpdated.listen(updatePlaylist),
      ImportController.onPlaylistDeleted.listen(deletePlaylist),
    ];

    TableLikes.reGenerateLikedPlaylist().whenComplete(() => TablePlaylist.selectAll().then(fillPlaylists));
  }

  @override
  void dispose() {
    for (final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }

  /// Clear and fill the playlists with the given playlists
  void fillPlaylists(Iterable<Playlist> i) {
    playlists.clear();
    playlists.addAll(i);
    notifyListeners();
  }

  /// Adds all the playlists given
  void addPlaylists(Iterable<Playlist> i) {
    playlists.addAll(i);
    notifyListeners();
  }

  /// Adds a playlist
  void addPlaylist(Playlist p) {
    playlists.add(p);
    notifyListeners();
  }

  /// Delete the given playlist
  void deletePlaylist(Playlist p) {
    playlists.removeWhere((element) => element.id == p.id);
    notifyListeners();
  }

  /// Update the given playlist
  void updatePlaylist(Playlist p) {
    for (int i = 0; i < playlists.length; i++) {
      if (playlists[i].id != p.id) continue;

      playlists[i] = p;
      notifyListeners();

      return;
    }

    addPlaylist(p);
  }

  /// Sorts the playlists
  void sortPlaylistsBy(PlaylistSort sort) {
    switch (sort) {
      case PlaylistSort.byId:
        playlists.sort((a, b) => a.id.compareTo(b.id));
      case PlaylistSort.byTitle:
        playlists.sort((a, b) => compareNatural(a.title, b.title));
      case PlaylistSort.byNumberOfTracks:
        playlists.sort((a, b) => a.songs.length.compareTo(b.songs.length));
      case PlaylistSort.byDuration:
        playlists.sort((a, b) => a.duration.compareTo(b.duration));
    }

    notifyListeners();
  }
}
