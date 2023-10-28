



import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';
import '../../core/data/MusicFetcher.dart';

class SongsModel extends ChangeNotifier {

  List<Song> songs = [];

  SongsModel(){

    update();
  }

  void update(){

    songs.clear();

    debugPrint("About to update music");

    MusicFetcher.instance.getAllMusic().then(
            (value) {
          debugPrint("Adding songs to song page");
          for (var element in value) {
            debugPrint("adding $element");
            songs.add(element);
          }
        }).then((value) => notifyListeners());
  }

  void add(Song s){
    songs.add(s);
    notifyListeners();
  }

  void remove(Song s){
    songs.remove(s);
    notifyListeners();
  }

  void removeFromTitle(String title){

    var c = songs.length;

    songs.removeWhere((element) => element.displayTitle.compareTo(title) == 0);

    if(c != songs.length)
      notifyListeners();
  }
}
