

import 'dart:math';

import 'package:dmus/core/audio/PlayQueue.dart';
import 'package:dmus/core/data/provider/SongsProvider.dart';

import '../Util.dart';
import 'DataEntity.dart';

final class QueueGeneration {
  QueueGeneration._();

  static Iterable<Song> getRandomOrdering(List<Song> s, int n ) {

    List<int> i = List.generate(s.length, (index) => index, growable: false)
      ..shuffle();

    return i.sublist(0, min(n, s.length))
        .map((e) => s[e]);
  }

  static void fillRandomN(PlayQueue q, int n) {

    if(SongsProvider.instance == null) {
      logging.warning("Cannot access SongsProvider, instance is null!");
      return;
    }

    List<Song> s = SongsProvider.instance!.songs;

    if(s.isEmpty || s.length == 1) {
      logging.warning("Cannot access generate queue because there is no songs!");
      return;
    }

    q.addAllToQueue(getRandomOrdering(s, n));
  }


  static void fillWithRandomWithPrioritySameArtist(PlayQueue q, Song song, int n) {

    if(SongsProvider.instance == null) {
      logging.warning("Cannot access SongsProvider, instance is null!");
      return;
    }

    List<Song> s = SongsProvider.instance!.songs;

    if(s.isEmpty) {
      logging.warning("Cannot access generate queue because there is no songs!");
      return;
    }

    q.addAllToQueue(getRandomOrdering(s.where((element) => element != song && element.songArtist() == song.songArtist()).toList(), n));
    q.addAllToQueue(getRandomOrdering(s.where((element) => element != song && element.songArtist() != song.songArtist()).toList(), n));
  }


}