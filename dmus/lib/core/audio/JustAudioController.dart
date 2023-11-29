



import 'dart:async';
import 'dart:collection';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:just_audio/just_audio.dart' as ja;

import '../Util.dart';
import '../data/DataEntity.dart';
import 'PlayQueue.dart';



final class JustAudioController extends BaseAudioHandler {

  JustAudioController._();

  static final JustAudioController _instance = JustAudioController._();

  static JustAudioController get instance => _instance;

  bool _isInit = false;
  bool _isDisposed = false;
  bool _isPaused = true;
  ShuffleOrder _shuffleOrder = ShuffleOrder.inOrder;
  bool _isRepeat = false;
  bool _currentIsNext = false;

  final _positionStream = StreamController<PlayerPosition>.broadcast();
  final _durationStream = StreamController<PlayerDuration>.broadcast();
  final _playingStream = StreamController<PlayerPlaying>.broadcast();
  final _indexStream = StreamController<PlayerIndex>.broadcast();
  final _playerStateStream = StreamController<PlayerStateExtended>.broadcast();
  final _playerSong = StreamController<PlayerSong>.broadcast();
  final _shuffleOrderStream = StreamController<PlayerShuffleOrder>.broadcast();
  final _repeatOrderStream = StreamController<PlayerRepeat>.broadcast();

  final _player = ja.AudioPlayer();
  final PlayQueue _playQueue = PlayQueue();
  late final AudioSession _audioSession;

  /// Get the current queue
  UnmodifiableListView<Song> get queueView{
    return _playQueue.readQueue;
  }

  Future<void> dispose() async {
    if(_isDisposed) {
      return;
    }

    _isDisposed = true;

    await _player.dispose();
  }

  Future<void> init() async {

    if(_isInit || _isDisposed) {
      return;
    }

    _isInit = true;

    _audioSession = await AudioSession.instance;

    await AudioService.init(
      builder: () => instance,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.dmus.channel.audio',
        androidNotificationChannelName: 'Music playback',
        androidNotificationOngoing: true
      ),
    );


    await _audioSession.configure(const AudioSessionConfiguration.music());

    _positionStream.addStream(_player.positionStream.map((event) => PlayerPosition(position: event, duration: _player.duration)));
    _durationStream.addStream(_player.durationStream.map((event) => PlayerDuration(position: _player.position, duration: event)));
    _playingStream.addStream(_player.playingStream.map((event) => PlayerPlaying(playing: event, song: _playQueue.current())));
    _indexStream.addStream(_player.currentIndexStream.map((event) => PlayerIndex(index: event)));
    _playerStateStream.addStream(_player.playerStateStream.map(_transformPlayerState));

    _playerStateStream.stream.listen(_onPlayerStateChanged);

    _player.playbackEventStream.map(_transformPlaybackEvent).pipe(playbackState);
  }

  Future<void> _onPlayerStateChanged(PlayerStateExtended event) async {
    if (event.processingState != ja.ProcessingState.completed) {
      return;
    }

    if(_isRepeat) {
      return await play();
    }

    switch(_shuffleOrder){

      case ShuffleOrder.inOrder:
        return await skipToNext();
      case ShuffleOrder.randomOrder:
        return await skipToRandom();
      case ShuffleOrder.reverseOrder:
        return await skipToPrevious();
    }

  }

  PlayerStateExtended _transformPlayerState(ja.PlayerState event) {

    switch(event.processingState) {
      case ja.ProcessingState.ready:
        _isPaused = !_player.playing;
        break;

      case ja.ProcessingState.loading:
      case ja.ProcessingState.buffering:
        _isPaused = true;
        break;

      case ja.ProcessingState.idle:
      case ja.ProcessingState.completed:
        _isPaused = false;
        break;
    }

    return PlayerStateExtended(paused: _isPaused, playing: event.playing, processingState: event.processingState);
  }

  PlaybackState _transformPlaybackEvent(ja.PlaybackEvent event){

    return PlaybackState(
        controls: [
          MediaControl.skipToPrevious,
          if(_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [1,0,2],
        processingState: const {
          ja.ProcessingState.idle : AudioProcessingState.idle,
          ja.ProcessingState.loading: AudioProcessingState.loading,
          ja.ProcessingState.buffering: AudioProcessingState.buffering,
          ja.ProcessingState.ready: AudioProcessingState.ready,
          ja.ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex
    );
  }

  /// Publish events when the repeat mode changes
  Stream<PlayerRepeat> get onRepeatChanged {
    return _repeatOrderStream.stream;
  }

  /// Publish events when the shuffle order changes
  Stream<PlayerShuffleOrder> get onShuffleOrderChanged {
    return _shuffleOrderStream.stream;
  }

  /// Publish events when the player song changes
  Stream<PlayerSong> get onPlayerSongChanged {
    return _playerSong.stream;
  }

  /// Publish events when the player state changes
  Stream<PlayerStateExtended> get onPlayerStateChanged {
    return _playerStateStream.stream;
  }

  /// Publish events when the song position changes (ie 1 second passes)
  Stream<PlayerPosition> get onPositionChanged {
    return _positionStream.stream;
  }

  /// Publish events when the duration of the song changes
  Stream<PlayerDuration> get onDurationChanged {
    return _durationStream.stream;
  }

  /// Publish events when the duration of the song changes
  Stream<PlayerPlaying> get onPlayingChanged {
    return _playingStream.stream;
  }

  Stream<PlayerIndex> get onPlayerIndexChanged {
    return _indexStream.stream;
  }

  @override
  Future<void> stop() async {
    if(!_isInit || _isDisposed) return;
    await _player.stop();
  }

  @override
  Future<void> pause() async {
    if(!_isInit || _isDisposed) return;
    await _player.pause();
  }

  @override
  Future<void> play() async {
    if(!_isInit || _isDisposed) return;
    if(_player.playerState.processingState == ja.ProcessingState.completed) {
      await seek(Duration.zero);
    }
    await _player.play();
  }

  @override
  Future<void> seek(Duration position) async {
    if(!_isInit || _isDisposed) return;
    await _player.seek(position);
  }

  @override
  Future<void> skipToQueueItem(int i) async {
    if(!_isInit || _isDisposed) return;
    _playQueue.jumpToIndex(i);
    await playSong(_playQueue.current());
  }

  @override
  Future<void> skipToNext() async {
    if(!_isInit || _isDisposed) return;

    Song? s;

    if(_currentIsNext) {
      _currentIsNext = false;
      s = _playQueue.current();
    } else {
      s = _playQueue.advanceNext();
    }

    if(s != null) {
      await _setAudioSource( s);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if(!_isInit || _isDisposed) return;

    Song? s;

    if(_currentIsNext) {
      _currentIsNext = false;
      s = _playQueue.current();
    } else {
      s = _playQueue.advancePrevious();
    }

    if(s != null) {
      await _setAudioSource( s);
    }
  }

  Future<void> skipToRandom() async {
    if(!_isInit || _isDisposed) return;

    Song? s = _playQueue.advanceRandom();

    if(s != null) {
      await _setAudioSource( s);
    }
  }

  Future<void> playSong(Song? song) async {
    if(!_isInit || _isDisposed) return;

    if(song == null) return await stop();

    _playQueue.jumpTo(song);

    await _setAudioSource(song);
  }


  Future<void> addNextToQueue(Song s) async {
    _playQueue.addToQueue(s);

  }

  double get playbackSpeed => _player.speed;

  Future<void> setPlaybackSpeed(double speed) async {
    if(!_isInit || _isDisposed) return;
    await _player.setSpeed(speed);
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    switch(shuffleMode){

      case AudioServiceShuffleMode.none:
        setMyShuffleMode(ShuffleOrder.inOrder);
      case AudioServiceShuffleMode.all:
        setMyShuffleMode(ShuffleOrder.randomOrder);
      case AudioServiceShuffleMode.group:
        setMyShuffleMode(ShuffleOrder.inOrder);
    }
  }

  void setMyShuffleMode(ShuffleOrder o)  {
    if(!_isInit || _isDisposed) return;
    _fireSetShuffleOrder(o);
  }

  void toggleShuffle(){
    if(_shuffleOrder == ShuffleOrder.inOrder) {
      setMyShuffleMode(ShuffleOrder.randomOrder);
    } else {
      setMyShuffleMode(ShuffleOrder.inOrder);
    }
  }

  void setRepeat(bool repeat){
    _fireSetRepeat(repeat);
  }

  void toggleRepeat(){
    _fireSetRepeat(!_isRepeat);
  }

  Future<void> _setAudioSource(Song song) async {
    if(!_isInit || _isDisposed) return;

    if(!await song.file.exists()) {
      return MessagePublisher.publishSomethingWentWrong("Cannot play ${song.file} because it does not exist!");
    }

    if(await _audioSession.setActive(true)) {
      _firePlayerSong(song);
      mediaItem.add(song.toMediaItem());
      await _player.setAudioSource(ja.AudioSource.file(song.file.path));
      await play();
    } else {
      MessagePublisher.publishSomethingWentWrong("Cannot play audio!");
    }
  }

  Future<void> playSongAt(int index) async {
    if(!_isInit || _isDisposed) return;

    logging.info("Playing song at $index");

    if(!_playQueue.canJump(index)) {
      logging.warning("Cannot jump to $index");
      return;
    }

    _playQueue.jumpToIndex(index);

    Song? s = _playQueue.current();

    await playSong(s);
  }

  Future<void> playPlaylist(Playlist p) async {
    if(!_isInit || _isDisposed || p.songs.isEmpty) return;

    await JustAudioController.instance.stopAndEmptyQueue();
    await JustAudioController.instance.queuePlaylist(p);
    await JustAudioController.instance.playSongAt(0);
  }

  Future<void> stopAndEmptyQueue() async {
    if(!_isInit || _isDisposed) return;

    _player.stop();

    await stop();

    _playQueue.clear();
  }

  Future<void> queuePlaylist(Playlist p) async {
    logging.finest("playing playlist ${p.toStringWithSongs()}");
    _playQueue.addAllToQueue(p.songs);
  }

  Future<void> removeQueueAt(int index) async {

    if(index < 0 || index >= _playQueue.length) return;

    if(index == _playQueue.currentPosition) {
      _currentIsNext = true;
    }

    Song? song = _playQueue.removeAt(index);

    if(_playQueue.state == QueueState.end && song != null) {
      _firePlayerSong(song);
    }
  }


  void _fireSetRepeat(bool newOrder){

    PlayerRepeat pso = PlayerRepeat(repeat: newOrder);

    _isRepeat = newOrder;

    _repeatOrderStream.add(pso);
  }

  void _fireSetShuffleOrder(ShuffleOrder newOrder){

    PlayerShuffleOrder pso = PlayerShuffleOrder(before: _shuffleOrder, after: newOrder);

    _shuffleOrder = newOrder;

    _shuffleOrderStream.add(pso);
  }

  void _firePlayerSong(Song song){
    _playerSong.add(PlayerSong(
        song: song,
        playerState: PlayerStateExtended(paused: _isPaused, playing: _player.playing, processingState: _player.processingState),
        duration: _player.duration,
        position: _player.position,
        index: _playQueue.currentPosition)
    );
  }
}