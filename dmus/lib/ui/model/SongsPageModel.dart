



import 'dart:async';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';

class SongsModel extends ChangeNotifier {

  List<Song> songs = [];

  late final StreamSubscription<Song> _songImportedSubscription;

  SongsModel(){

    _songImportedSubscription = ImportController.onSongImported.listen(_onSongImported);

    update();
  }

  @override
  void dispose(){

    _songImportedSubscription.cancel();
    super.dispose();
  }

  void _onSongImported(Song s) {
    if(songs.contains(s)) {
      return;
    }

    songs.add(s);
    notifyListeners();
  }

  void update(){


    TableSong.selectAllWithMetadata().then( (value) {

      songs.clear();
      songs.addAll(value);

    }).whenComplete((){
      notifyListeners();

      logging.info("Finished updating songs");
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

  void removeFromDb(Song s){

    TableSong.deleteSongById(s.id).then((value) {

      songs.remove(s);
      notifyListeners();
    });
  }

  void removeFromTitle(String title){

    var c = songs.length;

    songs.removeWhere((element) => element.title.compareTo(title) == 0);

    if(c != songs.length) {
      notifyListeners();
    }
  }
}
