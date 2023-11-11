


import 'package:just_audio/just_audio.dart';

final class PlayerPosition {

  final Duration position;
  final Duration? duration;

  const PlayerPosition({required this.position, required this.duration});
}

final class PlayerDuration {

  final Duration? duration;
  final Duration position;

  const PlayerDuration({required this.position, required this.duration});
}

final class PlayerPlaying {

  final bool playing;

  const PlayerPlaying({required this.playing});
}

final class PlayerIndex {

  final int? index;

  const PlayerIndex({required this.index});
}


final class PlayerStateExtended extends PlayerState {

  bool paused;

  PlayerStateExtended({required this.paused, required playing, required processingState})
      : super(playing, processingState);
}
