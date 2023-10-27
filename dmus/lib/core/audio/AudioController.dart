


import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import '../data/DataEntity.dart';

class AudioController {

  final AudioPlayer _player = AudioPlayer();
  final List<Song> _playQueue = [];

  final _currentlyPlayingNotifier = StreamController<Song?>();

  Song? _currentSong;
  bool _isPlayerReady = false;

  AudioController._();

  static final AudioController _instance = AudioController._();

  static AudioController get instance {
    return _instance;
  }

  factory AudioController() {
    return _instance;
  }

  Stream<Song?> get onSongChanged {
    return _currentlyPlayingNotifier.stream;
  }

  Stream<Duration> get onPositionChanged {
    return _player.onPositionChanged;
  }

  Stream<Duration> get onDurationChanged {
    return _player.onDurationChanged;
  }

  Stream<PlayerState> get onStateChanged {
    return _player.onPlayerStateChanged;
  }

  Stream<void> get onComplete {
    return _player.onPlayerComplete;
  }

  void _onLog(String event){
    debugPrint(event);
  }
  void _onError(Object e, [StackTrace? stackTrace]){
    debugPrint(e.toString());
  }


  void setup(){

    if(_isPlayerReady) {
      return;
    }

    _player.onLog.listen(
        _onLog,
        onError: _onError
    );

    _isPlayerReady = true;
  }

  bool isPlaying(){
    return _player.state == PlayerState.playing;
  }

  Future<void> stopAndEmptyQueue() async {

    await _player.stop();

    _playQueue.clear();
  }

  Future<void> togglePause() async{

    switch(_player.state){

      case PlayerState.stopped:
      case PlayerState.completed:
      case PlayerState.disposed:
        return;
      case PlayerState.playing:
        return await _player.pause();
      case PlayerState.paused:
        return await _player.resume();
    }
  }

  Future<void> playSong(Song src) async {

    if(src.file == null || src.file.path == null) {
      return;
    }

    _currentSong = src;

    _currentlyPlayingNotifier.add(src);

    await _player.play(DeviceFileSource(src.file.path!));
  }

  Future<void> playQueue() async {

    switch(_player.state){

      case PlayerState.disposed:
      case PlayerState.playing:
        _currentSong = null;
        return;
      case PlayerState.paused:
        return await _player.resume();

      case PlayerState.stopped:
      case PlayerState.completed:
        break;
    }

    while(_playQueue.isNotEmpty) {

      Song next = _playQueue.removeAt(0);

      if(next.file == null || next.file.path == null) {
        debugPrint("Could not play next song $next ");
        continue;
      }

      return await playSong(next);
    }
  }

  Future<void> queueSong(Song s) async {
    _playQueue.add(s);
    await playQueue();
  }




}

