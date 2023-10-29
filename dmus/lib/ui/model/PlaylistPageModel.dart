



import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';
import '../../core/data/MusicFetcher.dart';

class PlaylistModel extends ChangeNotifier {

  List<Playlist> playlists = [];

  PlaylistModel() {
    update();
  }

  void update(){

    TablePlaylist.selectAll().then((value) {

      playlists.clear();
      playlists.addAll(value.map((e) => Playlist(title: e.title)));
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
