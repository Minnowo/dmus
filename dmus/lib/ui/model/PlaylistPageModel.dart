



import 'dart:async';

import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';

class PlaylistModel extends ChangeNotifier {

  List<Playlist> playlists = [];


  late final List<StreamSubscription> _subscriptions;

  PlaylistModel() {

    _subscriptions = [
      ImportController.onPlaylistCreated.listen(_onPlaylistCreated),
      ImportController.onPlaylistUpdated.listen(_onPlaylistUpdated)
    ];

    update();
  }

  @override
  void dispose(){

    for(final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }

  void _onPlaylistUpdated(Playlist p) {

    for(int i = 0; i < playlists.length; i++){

      if(playlists[i].id == p.id) {
        playlists[i] = p;
        break;
      }
    }

    notifyListeners();
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
