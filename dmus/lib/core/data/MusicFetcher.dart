

import 'dart:io';

import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'DataEntity.dart';


import 'package:path/path.dart' as Path;

class MusicFetcher {

  static MusicFetcher instance = MusicFetcher();

  // this is the database rightnow
  static List<PlatformFile> files = [];

  void addFiles(List<PlatformFile> paths) {

    for (var e in paths) {
      addFile(e);
    }

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

    var s = await TableSong.selectAll();

    return s.map((e) => PlatformFile(name:Path.basename(e.songPath), size: e.id, path: e.songPath))
        .map((e) => Song(title: e.path!, duration: const Duration(milliseconds: 0), file: File(e.path!), metadata: const Metadata() ))
        .toList();
  }

  Future<List<Playlist>> getAllPlaylists() async {

    throw DoNothingAction();
  }

  Future<List<Album>> getAllAlbums() async {

    throw DoNothingAction();
  }


}