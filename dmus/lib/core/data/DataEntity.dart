import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import '../Util.dart';

abstract class DataEntity {

  int id;
  String title;
  Duration duration = const Duration(milliseconds: 0);

  DataEntity({required this.id, required this.title});

  DataEntity.withDuration({required this.id, required this.title, required this.duration});

  @override
  String toString() {
    return "<$runtimeType $id $title ${formatDuration(duration)}>";
  }
}


class Song extends DataEntity {

  File file;
  Metadata metadata;

  Song({required super.id, required super.title, required this.file, required this.metadata});

  Song.withDuration({required super.id, required super.title, required super.duration, required this.file, required this.metadata}) :
        super.withDuration();

}


class Playlist extends DataEntity {

  List<Song> songs = [];

  Playlist({required super.id, required super.title});

  Playlist.withSongs({required super.id, required super.title, required this.songs}) :
    super.withDuration(duration: songs.map((e) => e.duration).reduce((value, element) => value + element));

  Playlist.withDuration({required super.id, required super.title, required super.duration}) :
      super.withDuration();

  void updateDuration(){

    if(songs.isEmpty) {
      return;
    }
    super.duration = songs.map((e) => e.duration).reduce((value, element) => value + element);
  }

  @override
  String toString() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: ${songs.length}>";
  }

  String toStringWithSongs() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: $songs>";
  }
}

class Album extends DataEntity {
  List<Song> songs = [];

  Album({required super.id, required super.title});

  Album.withSongs({required super.id, required super.title, required this.songs}) :
        super.withDuration(duration: songs.map((e) => e.duration).reduce((value, element) => value + element));
}
