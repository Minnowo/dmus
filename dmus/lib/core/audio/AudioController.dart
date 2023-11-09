
import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:dmus/core/localstorage/dbimpl/TableHistory.dart';
import '../Util.dart';
import '../data/DataEntity.dart';



/// The main audio controller class
///
/// Responsible for playing music, the current queue, seeking,
/// pause, resume and dispatching events related to the audio state
final class AudioController {

  AudioController._();

  static final AudioPlayer _player = AudioPlayer();
  static final List<Song> _playQueue = [];
  static final List<Song> _playHistory = [];

  static final _currentlyPlayingNotifier = StreamController<Song?>.broadcast();

  static Song? _currentSong;
  static bool _isPlayerReady = false;


  /// Publish events when the song changes, either to null or another song
  static Stream<Song?> get onSongChanged {
    return _currentlyPlayingNotifier.stream;
  }


  /// Publish events when the song position changes (ie 1 second passes)
  static Stream<Duration> get onPositionChanged {
    return _player.onPositionChanged;
  }


  /// Publish events when the duration of the song changes
  static Stream<Duration> get onDurationChanged {
    return _player.onDurationChanged;
  }


  /// Publish events when player state changes,
  ///
  /// Possible states are paused, playing, stopped, completed, disposed
  static Stream<PlayerState> get onStateChanged {
    return _player.onPlayerStateChanged;
  }


  /// Publish events when the current song finishes playing
  ///
  /// This does not fire when it is canceled or changes song
  static Stream<void> get onComplete {
    return _player.onPlayerComplete;
  }


  /// Get the players current playback speed
  static double get playbackSpeed {
    return _player.playbackRate;
  }

  /// Get a read only view of the play queue
  static UnmodifiableListView<Song> get getPlayQueue {
    return UnmodifiableListView(_playQueue);
  }

  /// Get a read only view of the play history
  static UnmodifiableListView<Song> get getPlayHistory {
    return UnmodifiableListView(_playHistory);
  }



  /// Player internal logging hook
  static void _onLog(String event){
    logging.info(event);
  }


  /// Player internal logging hook
  static void _onError(Object e, [StackTrace? stackTrace]){
    logging.severe(e.toString());
  }


  /// Setup the player, can only be called once, and should be called at the start of the application
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


  /// Returns a bool indicating if the player state is playing
  static bool isPlaying(){
    return _player.state == PlayerState.playing;
  }

  
  /// Seek the player to the current position
  static Future<void> seekToPosition(Duration position) async {
    await _player.seek(position);
  }


  /// Set the current playback speed, this value should be greater than 0
  static Future<void> setPlaybackSpeed(double speed) async {
    if(speed <= 0) {
      logging.warning("Cannot set playback rate to 0 or less");
      return;
    }

    await _player.setPlaybackRate(speed);
  }


  /// Queue the given song so that it plays next
  static Future<void> queueSongNext(Song s) async {
    _playQueue.insert(0, s);
  }


  /// Put the given song at the end of the play queue
  static Future<void> queueSong(Song s) async {
    _playQueue.add(s);
  }


  /// Put the given playlist at the end of the play queue
  static Future<void> queuePlaylist(Playlist p) async {
    logging.info("playing playlist ${p.toStringWithSongs()}");
    _playQueue.addAll(p.songs);
  }


  /// Stop the player and empty the play queue
  static Future<void> stopAndEmptyQueue() async {

    setCurrentlyPlaying(null);

    await stop();

    _playQueue.clear();
  }


  /// Pause the player
  static Future<void> pause() async {
    logging.info("Pausing playback");
    await _player.pause();
  }


  /// Resume the player
  static Future<void> resume() async {
    logging.info("Resuming playback");
    await _player.resume();
  }


  /// Stops the player
  static Future<void> stop() async {

    await _player.pause();
    await seekToPosition(const Duration(seconds: 0));
  }


  /// Toggles between playing and pause state if possible
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


  /// Resumes from paused or tries to play the last played song
  static Future<void> resumePlayLast() async {

    logging.info(_player.state);

    if(_player.state == PlayerState.paused) {

      if(_currentSong != null) {
        return await resume();
      }
    }

    switch(_player.state){

      case PlayerState.playing:
      case PlayerState.disposed:
        return;

      case PlayerState.paused:
      case PlayerState.stopped:
      case PlayerState.completed:

        Song? last = _playHistory.lastOrNull;

        if(last == null) {
          return;
        }

        await playSong(last);

        return await resume();
    }
  }


  /// Set the currently playing song to this value
  ///
  /// Also updates the playHistory and publishes events for song changing
  static void setCurrentlyPlaying(Song? src) {

    if(_currentSong != null) {
      _playHistory.add(_currentSong!);
    }

    _currentSong = src;

    _currentlyPlayingNotifier.add(src);
  }


  /// Play the given song and update the currently playing song
  ///
  /// Does not play anything if the song is null
  static Future<void> playSong(Song? src) async {

    logging.info("Playing song $src");

    setCurrentlyPlaying(src);

    await setPlaybackSpeed(1);

    if(src != null) {

      await TableHistory.addToHistory(src.id);
      await _player.play(DeviceFileSource(src.file.path));
    }
  }


  /// Plays the previous song
  ///
  /// Adjust the history and queue accordingly
  ///
  /// This can be used to seek to the previous and next song as needed
  static Future<void> playPrevious() async {

    switch(_player.state){
      case PlayerState.disposed:
        return setCurrentlyPlaying(null);
      case PlayerState.playing:
      case PlayerState.paused:
      case PlayerState.stopped:
      case PlayerState.completed:
        break;
    }

    while(_playHistory.isNotEmpty) {

      bool requeue = _currentSong != null;

      Song next = _playHistory.removeAt(_playHistory.length - 1);

      await playSong(next);

      if(requeue && _playHistory.isNotEmpty) {

        Song last = _playHistory.removeAt(_playHistory.length - 1);

        queueSongNext(last);

        logging.info("==================");
        logging.info(_playHistory);
        logging.info(_currentSong);
        logging.info(_playQueue);
      }
      return;
    }
  }


  /// Plays the next song
  ///
  /// Adjust the history and queue accordingly
  ///
  /// This can be used to seek to the previous and next song as needed
  static Future<void> playNext() async {

    switch(_player.state){
      case PlayerState.disposed:
        return setCurrentlyPlaying(null);
      case PlayerState.playing:
      case PlayerState.paused:
      case PlayerState.stopped:
      case PlayerState.completed:
        break;
    }

    while(_playQueue.isNotEmpty) {

      Song next = _playQueue.removeAt(0);

      return await playSong(next);
    }
  }


  /// Resumes the song or plays the next song if there is no song playing
  static Future<void> playQueue() async {

    switch(_player.state){
      case PlayerState.playing:
        return;
      case PlayerState.disposed:
        return setCurrentlyPlaying(null);
      case PlayerState.paused:
        return await _player.resume();

      case PlayerState.stopped:
      case PlayerState.completed:
        break;
    }

    await playNext();
  }
}

