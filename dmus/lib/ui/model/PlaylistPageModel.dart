



import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';
import '../../core/data/MusicFetcher.dart';

class PlaylistModel extends ChangeNotifier {

  List<Playlist> playlists = [];

  void update(){

    playlists.clear();

    debugPrint("About to update music");

    // MusicFetcher.instance.getAllMusic().then(
    //         (value) {
    //       debugPrint("Adding songs to song page");
    //       for (var element in value) {
    //         debugPrint("adding $element");
    //         playlists.add(element);
    //       }
    //     });
    //
    notifyListeners();
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

    playlists.removeWhere((element) => element.displayTitle.compareTo(title) == 0);

    if(c != playlists.length)
      notifyListeners();
  }
}
