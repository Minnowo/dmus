



import 'dart:async';

import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';

class PlaylistModel extends ChangeNotifier {

  List<Playlist> playlists = [];

  late final StreamSubscription<Playlist> _playlistCreatedSubscription;

  PlaylistModel() {

    _playlistCreatedSubscription = ImportController.onPlaylistCreated.listen(_onPlaylistCreated);

    update();
  }

  @override
  void dispose(){

    _playlistCreatedSubscription.cancel();
    super.dispose();
  }

  void _onPlaylistCreated(Playlist p) {
    if(playlists.contains(p)) {
      return;
    }

    playlists.add(p);
    notifyListeners();
  }

  void update(){

    TablePlaylist.selectAll().then((value) {

      playlists.clear();
      playlists.addAll(value);
      notifyListeners();
    });

  }

  void add(Playlist p){
    playlists.add(p);
    notifyListeners();
  }

  void remove(Playlist p){
    playlists.remove(p);
    notifyListeners();
  }

  void removeFromTitle(String title){

    var c = playlists.length;

    playlists.removeWhere((element) => element.title.compareTo(title) == 0);

    if(c != playlists.length) {
      notifyListeners();
    }
  }
}
