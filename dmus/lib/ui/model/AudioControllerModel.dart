



import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:flutter/cupertino.dart';

import '../../core/data/DataEntity.dart';

class AudioControllerModel extends ChangeNotifier {

  bool isPlaying = false;
  bool isPaused = false;
  // PlayerState state = PlayerState.stopped;

  Duration duration = const Duration(microseconds: 0);
  Duration position = const Duration(microseconds: 0);

  Song? currentlyPlaying;


  late final List<StreamSubscription> _subscriptions;

  AudioControllerModel(){

    _subscriptions = [
      // AudioController.onPositionChanged.listen(_onPositionChanged),
      // AudioController.onDurationChanged.listen(_onDurationChanged),
      // AudioController.onStateChanged.listen(_onStateChanged),
      // AudioController.onComplete.listen(_onPlayerComplete),
      // AudioController.onSongChanged.listen(_onSongChanged),
    ];
  }

  @override
  void dispose() {
    for(var i in _subscriptions) {
      i.cancel();
    }
    super.dispose();
  }

  void _onSongChanged(Song? event){
    currentlyPlaying = event;
    notifyListeners();
  }

  void _onPositionChanged(Duration event){
    position = event;
    notifyListeners();
  }

  void _onDurationChanged(Duration event){
    duration = event;
    notifyListeners();
  }

  void _onPlayerComplete(void data) {
    debugPrint("Player is finished with current audio!");
    isPlaying = false;
    isPaused = false;
    notifyListeners();
  }

  // void _onStateChanged(PlayerState state) {
  //   this.state = state;
  //
  //   isPlaying = (state == PlayerState.playing);
  //   isPaused = (state == PlayerState.paused);
  //
  //   notifyListeners();
  // }
}


