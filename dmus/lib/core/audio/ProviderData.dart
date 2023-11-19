


import 'package:just_audio/just_audio.dart';

import '../data/DataEntity.dart';


enum ShuffleOrder {

  inOrder,
  randomOrder,
  reverseOrder,
}


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
  final Song? song;

  const PlayerPlaying({required this.playing, required this.song});
}

final class PlayerIndex {

  final int? index;

  const PlayerIndex({required this.index});
}


final class PlayerStateExtended extends PlayerState {

  final bool paused;

  PlayerStateExtended({required this.paused, required playing, required processingState})
      : super(playing, processingState);
}

final class PlayerSong {

  final int index;
  final Song? song;
  final PlayerStateExtended playerState;
  final Duration? duration;
  final Duration position;

  PlayerSong({required this.song, required this.playerState, required this.duration, required this.position, required this.index});

  @override
  int get hashCode => Object.hash(index, song, playerState, duration, position);

  @override
  bool operator ==(Object other) => identical(this, other) || (
      other is PlayerSong &&
          other.index == index &&
          other.song == song &&
          other.playerState == playerState
  );
}


final class PlayerShuffleOrder {
  final ShuffleOrder before;
  final ShuffleOrder after;

  const PlayerShuffleOrder({required this.before, required this.after});
}
