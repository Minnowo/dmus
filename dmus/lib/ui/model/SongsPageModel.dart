



import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';

class SongsModel extends ChangeNotifier {

  List<Song> songs = [];

  SongsModel(){

    update();
  }

  void update(){


    TableSong.selectAllWithMetadata().then( (value) {

      songs.clear();
      songs.addAll(value);

    }).whenComplete((){
      notifyListeners();

      logging.info("Finished updating");
    });
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

    songs.removeWhere((element) => element.title.compareTo(title) == 0);

    if(c != songs.length) {
      notifyListeners();
    }
  }
}
