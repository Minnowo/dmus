import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

abstract class DataEntity {
  String displayTitle;

  double duration;

  DataEntity(this.displayTitle, this.duration);
}



class Song {

  String title;
  File file;
  Duration duration;
  Metadata metadata;

  Song({required this.title, required this.duration, required this.file, required this.metadata});

}


// class Song extends DataEntity {
//
//   PlatformFile file;
//
//   Song(this.file, String displayTitle, double duration) : super(displayTitle, duration);
//
//   @override
//   String toString() {
//     return "<Song $displayTitle file: $file>";
//   }
// }

class Playlist extends DataEntity {
  List<Song> songs;

  Playlist(this.songs, String displayTitle, double duration)
      : super(displayTitle, duration) {

  }
}

class Album extends Playlist {
  Album(List<Song> songs, String displayTitle, double duration)
      : super(songs, displayTitle, duration);
}
