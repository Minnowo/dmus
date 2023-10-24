

import 'package:flutter/cupertino.dart';

import 'DataEntity.dart';


class MusicFetcher {

  Future<List<Song>> getAllMusic() async {

    return [
      Song("Song title 1", 167),
      Song("Song title 1", 167.0),
      Song("Song title 2", 210.5),
      Song("Song title 3", 183.25),
      Song("Song title 4", 194.75),
      Song("Song title 5", 152.0),

      Song("Song title 1", 167),
      Song("Song title 1", 167.0),
      Song("Song title 2", 210.5),
      Song("Song title 3", 183.25),
      Song("Song title 4", 194.75),
      Song("Song title 5", 152.0),
    ];
  }

  Future<List<Playlist>> getAllPlaylists() async {

    throw DoNothingAction();
  }

  Future<List<Album>> getAllAlbums() async {

    throw DoNothingAction();
  }


}