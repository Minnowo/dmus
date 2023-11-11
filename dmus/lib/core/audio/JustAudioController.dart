



import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:just_audio/just_audio.dart';

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

  final _positionStream = StreamController<PlayerPosition>.broadcast();
  final _durationStream = StreamController<PlayerDuration>.broadcast();
  final _playingStream = StreamController<PlayerPlaying>.broadcast();
  final _indexStream = StreamController<PlayerIndex>.broadcast();
  final _playerStateStream = StreamController<PlayerStateExtended>.broadcast();
  final _playerSong = StreamController<PlayerSong>.broadcast();

  final _player = AudioPlayer();
  final PlayQueue _playQueue = PlayQueue();

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

    final session = await AudioSession.instance;

    await AudioService.init(
      builder: () => instance,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.example.dmus.channel.audio',
        androidNotificationChannelName: 'Music playback',
        androidNotificationOngoing: true
      ),
    );

    await session.configure(const AudioSessionConfiguration.music());

    _positionStream.addStream(_player.positionStream.map((event) => PlayerPosition(position: event, duration: _player.duration)));
    _durationStream.addStream(_player.durationStream.map((event) => PlayerDuration(position: _player.position, duration: event)));
    _playingStream.addStream(_player.playingStream.map((event) => PlayerPlaying(playing: event, song: _playQueue.current())));
    _indexStream.addStream(_player.currentIndexStream.map((event) => PlayerIndex(index: event)));
    _playerStateStream.addStream(_player.playerStateStream.map(_transformPlayerState));

    _player.playbackEventStream.map(_transformPlaybackEvent).pipe(playbackState);
  }

  PlayerStateExtended _transformPlayerState(PlayerState event) {

    switch(event.processingState) {
      case ProcessingState.ready:
        _isPaused = !_player.playing;
        break;

      case ProcessingState.loading:
      case ProcessingState.buffering:
        _isPaused = true;
        break;

      case ProcessingState.idle:
      case ProcessingState.completed:
        _isPaused = false;
        break;
    }

    return PlayerStateExtended(paused: _isPaused, playing: event.playing, processingState: event.processingState);
  }

  PlaybackState _transformPlaybackEvent(PlaybackEvent event){

    return PlaybackState(
        controls: [
          MediaControl.skipToNext,
          MediaControl.skipToPrevious,
          if(_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle : AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,

        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex
    );
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
    if(_player.playerState.processingState == ProcessingState.completed) {
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

    Song? s = _playQueue.advanceNext();

    if(s != null) {
      await _setAudioSource( s);
    }
  }

  @override
  Future<void> skipToPrevious() async {
    if(!_isInit || _isDisposed) return;

    Song? s = _playQueue.advancePrevious();

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

  double get playbackSpeed => _player.speed;

  Future<void> setPlaybackSpeed(double speed) async {
    if(!_isInit || _isDisposed) return;
    await _player.setSpeed(speed);
  }

  Future<void> _setAudioSource(Song song) async {

    if(!await song.file.exists()) {
      return MessagePublisher.publishSomethingWentWrong("Cannot play ${song.file} because it does not exist!");
    }

    firePlayerSong(song);
    mediaItem.add(song.toMediaItem());
    await _player.setAudioSource(AudioSource.file(song.file.path));
  }

  void firePlayerSong(Song song){
    _playerSong.add(PlayerSong(
        song: song,
        playerState: PlayerStateExtended(paused: _isPaused, playing: _player.playing, processingState: _player.processingState),
        duration: _player.duration,
        position: _player.position,
        index: _playQueue.currentPosition)
    );
  }
}