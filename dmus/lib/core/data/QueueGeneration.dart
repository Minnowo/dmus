import 'package:dmus/core/audio/PlayQueue.dart';
import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';

import '../Util.dart';
import 'DataEntity.dart';
import 'QueueGenerationAlgorithm.dart';

final class QueueGeneration {
  QueueGeneration._();

  static QueueGenerationAlgorithm get _algorithm => queueGenerationAlgorithmFor(SettingsHandler.queueAlgorithm);

  static Future<void> fillRandomN(PlayQueue q, int n) async {
    if (SongsProvider.instance == null) {
      logging.warning("Cannot access SongsProvider, instance is null!");
      return;
    }

    List<Song> s = SongsProvider.instance!.songs;

    if (s.isEmpty || s.length == 1) {
      logging.warning("Cannot access generate queue because there is no songs!");
      return;
    }

    final context = QueueGenerationContext(alreadyQueued: q.readQueue, contextSong: q.current());

    q.addAllToQueue(await _algorithm.selectSongs(s, n, context));
  }

  static Future<void> fillWithRandomWithPrioritySameArtist(PlayQueue q, Song song, int n) async {
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
    final context = QueueGenerationContext(alreadyQueued: q.readQueue, contextSong: song);

    q.addAllToQueue(await algorithm.selectSongs(
        s.where((element) => element != song && element.songArtist() == song.songArtist()).toList(), n, context));
    q.addAllToQueue(await algorithm.selectSongs(
        s.where((element) => element != song && element.songArtist() != song.songArtist()).toList(), n, context));
  }
}
