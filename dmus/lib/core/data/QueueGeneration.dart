import 'package:dmus/core/audio/PlayQueue.dart';
import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';

import '../Util.dart';
import 'DataEntity.dart';
import 'QueueGenerationAlgorithm.dart';

final class QueueGeneration {
  QueueGeneration._();

  static QueueGenerationAlgorithm get _algorithm => queueGenerationAlgorithmFor(SettingsHandler.queueAlgorithm);

  static void fillRandomN(PlayQueue q, int n) {
    if (SongsProvider.instance == null) {
      logging.warning("Cannot access SongsProvider, instance is null!");
      return;
    }

    List<Song> s = SongsProvider.instance!.songs;

    if (s.isEmpty || s.length == 1) {
      logging.warning("Cannot access generate queue because there is no songs!");
      return;
    }

    q.addAllToQueue(_algorithm.selectSongs(s, n));
  }

  static void fillWithRandomWithPrioritySameArtist(PlayQueue q, Song song, int n) {
    if (SongsProvider.instance == null) {
      logging.warning("Cannot access SongsProvider, instance is null!");
      return;
    }

    List<Song> s = SongsProvider.instance!.songs;

    if (s.isEmpty) {
      logging.warning("Cannot access generate queue because there is no songs!");
      return;
    }

    final algorithm = _algorithm;

    q.addAllToQueue(algorithm.selectSongs(
        s.where((element) => element != song && element.songArtist() == song.songArtist()).toList(), n));
    q.addAllToQueue(algorithm.selectSongs(
        s.where((element) => element != song && element.songArtist() != song.songArtist()).toList(), n));
  }
}
