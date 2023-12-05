

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../localstorage/ImportController.dart';
import '../../localstorage/dbimpl/TableSong.dart';
import '../DataEntity.dart';

class SongsProvider extends ChangeNotifier {

  static SongsProvider? get  instance => _instance;
  static SongsProvider? _instance;

  late final List<StreamSubscription> _subscriptions;

  final List<Song> songs = [];

  SongsProvider() {

    _instance = this;

    _subscriptions = [
      ImportController.onSongImported.listen(addSong),
      ImportController.onSongDeleted.listen(deleteSong),
      ImportController.onSongDeletedId.listen(deleteSongById)
    ];

    TableSong.selectAllWithMetadata().then(fillSongs);
  }

  @override
  void dispose() {

    for(final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }

  /// Clears and fills the songs with the given songs
  void fillSongs(Iterable<Song> s) {

    songs.clear();
    songs.addAll(s);
    notifyListeners();
  }


  /// Adds all the songs to the list if they are not already in the list
  void addSongs(Iterable<Song> s) {

    final l = songs.length;

    songs.addAll(s.where((e) => !songs.any((e1) => e1.id == e.id)));

    if(l != songs.length) {
      notifyListeners();
    }
  }


  /// Adds the song to the list if it does not exist in the list
  void addSong(Song s) {

    for(final i in songs){
      if(i.id == s.id) {
        return;
      }
    }

    songs.add(s);
    notifyListeners();
  }


  /// Removes all songs from the list with the given song id
  void deleteSongById(int s) {

    final l = songs.length;

    songs.removeWhere((e) => e.id == s);

    if(l != songs.length) {
      notifyListeners();
    }
  }


  /// Removes all songs from the list with the given song
  void deleteSong(Song s) {
    deleteSongById(s.id);
  }


  /// Sorts the songs
  void sortSongsBy(SongSort sort){

    switch(sort) {
      case SongSort.byId:
        songs.sort((a, b) => a.id.compareTo(b.id));
        break;
      case SongSort.byTitle:
        songs.sort((a, b) => compareNatural(a.title, b.title));
        break;
      case SongSort.byArtist:
        songs.sort((a, b) => compareNatural(a.songArtist(), b.songArtist()));
        break;
      case SongSort.byAlbum:
        songs.sort((a, b) => compareNatural(a.songAlbum(), b.songAlbum()));
        break;
      case SongSort.byDuration:
        songs.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }

    notifyListeners();
  }
}