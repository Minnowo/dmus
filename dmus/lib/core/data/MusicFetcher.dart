

import 'dart:io';

import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';

import 'DataEntity.dart';


import 'package:path/path.dart' as Path;

class MusicFetcher {

  static MusicFetcher instance = MusicFetcher();

  // this is the database rightnow
  static List<PlatformFile> files = [];

  void addFiles(List<PlatformFile> paths) {

    paths.forEach((e) => addFile(e));

  }

  void addFile(PlatformFile path){
    if(path.path == null || files.contains(path)) {
      return;
    }
    files.add(path);
    TableSong.insertSong(File(path.path!));
    debugPrint("Adding $path to music list");
  }

  Future<List<Song>> getAllMusic() async {

    var s = await TableSong.selectAllSongs();

    return s.map((e) => PlatformFile(name:Path.basename(e.song_path), size: e.id, path: e.song_path)).map((e) => Song(e, e.name, 0)).toList();
  }

  Future<List<Playlist>> getAllPlaylists() async {

    throw DoNothingAction();
  }

  Future<List<Album>> getAllAlbums() async {

    throw DoNothingAction();
  }


}