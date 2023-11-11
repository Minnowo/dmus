
import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:dmus/core/audio/PlayQueue.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
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
  static final PlayQueue _playQueue = PlayQueue();

  static final _currentlyPlayingNotifier = StreamController<Song?>.broadcast();

  static Song? _currentSong;
  static bool _isStopped = false;
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


  /// Get the current queue
  static UnmodifiableListView<Song> get queue{
    return _playQueue.readQueue;
  }

  static int get queuePosition{
    return _playQueue.currentPosition;
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
    _player.onPlayerStateChanged.listen((event) { if(event == PlayerState.stopped) _isStopped = true; });

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
    _playQueue.queueNext(s);
  }


  /// Put the given song at the end of the play queue
  static Future<void> queueSong(Song s) async {
    _playQueue.addToQueue(s);
  }


  /// Put the given playlist at the end of the play queue
  static Future<void> queuePlaylist(Playlist p) async {
    logging.info("playing playlist ${p.toStringWithSongs()}");
    _playQueue.addAllToQueue(p.songs);
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


  /// Resume the player
  static Future<void> resumeOrPlay(Song s) async {

    if(_isStopped) {
      await playSong(s, true);
    } else {
      await _player.resume();
    }
  }


  /// Stops the player
  static Future<void> stop() async {

    await _player.stop();
    await seekToPosition(const Duration(seconds: 0));
    setCurrentlyPlaying(null);
    _isStopped = true;
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

        Song? last = _playQueue.current();

        if(last == null) {
          return;
        }

        await playSong(last, false);

        return await resume();
    }
  }


  /// Set the currently playing song to this value
  ///
  /// Also updates the playHistory and publishes events for song changing
  static void setCurrentlyPlaying(Song? src) {

    _currentSong = src;

    _currentlyPlayingNotifier.add(src);
  }


  /// Play the given song at the given index of the queue
  static Future<void> playSongAt(int index) async {

    logging.info("Playing song at $index");

    if(!_playQueue.canJump(index)) {
      logging.warning("Cannot jump to $index");
      return;
    }

    _playQueue.jumpToIndex(index);

    Song? s = _playQueue.current();

    await playSong(s, false);
  }


  /// Play the given song and update the currently playing song
  ///
  /// Does not play anything if the song is null
  static Future<void> playSong(Song? src, bool jumpQueue) async {

    logging.info("Playing song $src");

    await setPlaybackSpeed(1);

    if(src != null) {

      if(jumpQueue) {
        _playQueue.jumpTo(src);
      }

      if(await src.file.exists()) {

        await TableHistory.addToHistory(src.id);
        await _player.play(DeviceFileSource(src.file.path));
        _isStopped = true;

      } else {
        MessagePublisher.publishSomethingWentWrong("Cannot play ${src.file} because it does not exist!");
      }
    }

    setCurrentlyPlaying(src);
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

    Song? prev = _playQueue.advancePrevious();

    if(prev == null) return;

    await playSong(prev, false);
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

    Song? next = _playQueue.advanceNext();

    if(next == null) return;

    await playSong(next, false);
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

