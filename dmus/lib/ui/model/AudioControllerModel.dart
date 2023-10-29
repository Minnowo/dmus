



import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import '../../core/audio/AudioController.dart';
import '../../core/data/DataEntity.dart';

class AudioControllerModel extends ChangeNotifier {

  bool isPlaying = false;
  bool isPaused = false;
  PlayerState state = PlayerState.stopped;

  Duration duration = const Duration(microseconds: 0);
  Duration position = const Duration(microseconds: 0);

  Song? currentlyPlaying = null;


  AudioControllerModel(){

    AudioController.instance.onPositionChanged.listen(_onPositionChanged);
    AudioController.instance.onDurationChanged.listen(_onDurationChanged);
    AudioController.instance.onStateChanged.listen(_onStateChanged);
    AudioController.instance.onComplete.listen(_onPlayerComplete);
    AudioController.instance.onSongChanged.listen(_onSongChanged);


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

  void _onStateChanged(PlayerState state) {
    this.state = state;
    if (state == PlayerState.playing) {
      isPlaying = true;
      isPaused = false;
    } else if (state == PlayerState.paused) {
      isPlaying = false;
      isPaused = true;
    }

   isPlaying = (state == PlayerState.playing);
    isPaused = (state == PlayerState.paused);

    notifyListeners();
  }

  void pause() {
    if (AudioController.instance.isPlaying())
    {
      AudioController.instance.togglePause();
      notifyListeners();
    }
  }

  void resume()
  {
    AudioController.instance.togglePause();
    notifyListeners();
  }

  void stopSong()
  {
    debugPrint("Audio Player Stopped");
    isPlaying = false;
    isPaused = false;
    notifyListeners();
  }



}


