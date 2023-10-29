import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import '../Util.dart';

abstract class DataEntity {

  String title;
  Duration duration = const Duration(milliseconds: 0);

  DataEntity({required this.title});

  DataEntity.withDuration({required this.title, required this.duration});

  @override
  String toString() {
    return "<$runtimeType $title ${formatDuration(duration)}>";
  }
}



class Song extends DataEntity {

  File file;
  Metadata metadata;

  Song({required super.title, required this.file, required this.metadata});

  Song.withDuration({required String title, required Duration duration, required this.file, required this.metadata}) :
        super.withDuration(title: title, duration: duration);

}


class Playlist extends DataEntity {

  List<Song> songs = [];

  Playlist({required super.title});

  Playlist.withSongs({required String title, required this.songs}) :
    super.withDuration(title: title, duration: songs.map((e) => e.duration).reduce((value, element) => value + element));

  Playlist.withDuration({required String title, required Duration duration}) :
      super.withDuration(title: title, duration: duration);

}

class Album  {
  String title;
  List<Song> songs = [];

  Album({required this.title});

  Album.withSongs({required this.title, required this.songs});
}
