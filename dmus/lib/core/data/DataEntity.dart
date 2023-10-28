import 'package:file_picker/file_picker.dart';

abstract class DataEntity {
  String displayTitle;

  double duration;

  DataEntity(this.displayTitle, this.duration);
}

class Song extends DataEntity {

  PlatformFile file;

  Song(this.file, String displayTitle, double duration) : super(displayTitle, duration);

  @override
  String toString() {
    return "<Song $displayTitle file: $file>";
  }
}

class Playlist extends DataEntity {
  List<Song> songs;

  Playlist(this.songs, String displayTitle, double duration)
      : super(displayTitle, duration) {

    this.duration = songs
        .map((s) => s.duration)
        .reduce((value, element) => value + element);
  }
}

class Album extends Playlist {
  Album(List<Song> songs, String displayTitle, double duration)
      : super(songs, displayTitle, duration);
}
