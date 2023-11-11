



import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:dmus/core/audio/ProviderData.dart';
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

  final PlayQueue _playQueue = PlayQueue();
  final _positionStream = StreamController<PlayerPosition>.broadcast();
  final _durationStream = StreamController<PlayerDuration>.broadcast();
  final _playingStream = StreamController<PlayerPlaying>.broadcast();
  final _indexStream = StreamController<PlayerIndex>.broadcast();
  final _playerStateStream = StreamController<PlayerStateExtended>.broadcast();

  final _player = AudioPlayer();

  Future<void> dispose() async {
    if(_isDisposed) {
      return;
    }

    _isDisposed = true;

    await _player.dispose();
  }
  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );
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
    _playingStream.addStream(_player.playingStream.map((event) => PlayerPlaying(playing: event)));
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
          MediaControl.rewind,
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

  /// Publish events when the song position changes (ie 1 second passes)
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

  Future<void> playSong(Song? song) async {
    if(!_isInit || _isDisposed) return;

    if(song == null) return await stop();

    mediaItem.add(song.toMediaItem());

    await _player.setAudioSource(AudioSource.file(song.file.path));
  }

  double get playbackSpeed => _player.speed;

  Future<void> setPlaybackSpeed(double speed) async {
    if(!_isInit || _isDisposed) return;
    await _player.setSpeed(speed);
  }

}