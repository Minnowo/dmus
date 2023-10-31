


import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import '../Util.dart';
import '../data/DataEntity.dart';

class AudioController {

  static final AudioPlayer _player = AudioPlayer();
  static final List<Song> _playQueue = [];

  static final _currentlyPlayingNotifier = StreamController<Song?>.broadcast();

  static Song? _currentSong;
  static bool _isPlayerReady = false;

  static final AudioController _instance = AudioController._();

  AudioController._();

  static AudioController get instance {
    return _instance;
  }

  factory AudioController() {
    return _instance;
  }

  static Stream<Song?> get onSongChanged {
    return _currentlyPlayingNotifier.stream;
  }

  static Stream<Duration> get onPositionChanged {
    return _player.onPositionChanged;
  }

  static Stream<Duration> get onDurationChanged {
    return _player.onDurationChanged;
  }

  static Stream<PlayerState> get onStateChanged {
    return _player.onPlayerStateChanged;
  }

  static Stream<void> get onComplete {
    return _player.onPlayerComplete;
  }

  static void _onLog(String event){
    logging.info(event);
  }
  static void _onError(Object e, [StackTrace? stackTrace]){
    logging.severe(e.toString());
  }


  static void setup(){

    if(_isPlayerReady) {
      return;
    }

    _player.onLog.listen(
        _onLog,
        onError: _onError
    );
    _player.onPlayerComplete.listen((event) { playQueue().then((value) => logging.info("Playing next song..."));});

    _isPlayerReady = true;
  }

  static bool isPlaying(){
    return _player.state == PlayerState.playing;
  }

  static Future<void> stopAndEmptyQueue() async {

    await _player.stop();

    _playQueue.clear();
  }

  static Future<void> togglePause() async{

    switch(_player.state){

      case PlayerState.stopped:
      case PlayerState.completed:
      case PlayerState.disposed:
        return;
      case PlayerState.playing:
        return await pause();
      case PlayerState.paused:
        return await resume();
    }
  }

  static Future<void> pause() async {
    logging.info("Pausing playback");
    await _player.pause();
  }

  static Future<void> resume() async {
    logging.info("Resuming playback");
    await _player.resume();
  }

  static Future<void> playSong(Song src) async {

    if(src.file == null || src.file.path == null) {
      return;
    }

    logging.info("Playing song $src");

    _currentSong = src;

    _currentlyPlayingNotifier.add(src);

    await _player.play(DeviceFileSource(src.file.path!));
  }

  static Future<void> playQueue() async {

    switch(_player.state){
      case PlayerState.playing:
        return;
      case PlayerState.disposed:
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
        logging.warning("Could not play next song $next ");
        continue;
      }

      return await playSong(next);
    }
  }

  static Future<void> queueSong(Song s) async {
    _playQueue.add(s);
  }

  static Future<void> queuePlaylist(Playlist p) async {
    logging.info("playing playlist ${p.toStringWithSongs()}");
    _playQueue.addAll(p.songs);
  }
}

