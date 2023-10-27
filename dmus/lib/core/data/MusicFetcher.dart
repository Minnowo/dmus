

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'DataEntity.dart';


class MusicFetcher {

  static MusicFetcher instance = MusicFetcher();

  static List<PlatformFile> files = [];

  void addFiles(List<PlatformFile> paths) {

    paths.forEach((e) => addFile(e));

  }

  void addFile(PlatformFile path){
    files.add(path);
    debugPrint("Adding $path to music list");
  }

  Future<List<Song>> getAllMusic() async {

    return files.map((e) => Song(e, e.name, 0)).toList();
  }

  Future<List<Playlist>> getAllPlaylists() async {

    throw DoNothingAction();
  }

  Future<List<Album>> getAllAlbums() async {

    throw DoNothingAction();
  }


}