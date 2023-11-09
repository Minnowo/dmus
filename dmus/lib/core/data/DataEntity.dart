import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../Util.dart';



/// Enum used to quickly determine which type of entity
/// a given DataEntity is
enum EntityType {
  song,
  playlist,
  album
}


/// The base DataEntity class
///
/// A DataEntity is basically some type of media that will be
/// stored in the database, and also shown the the user
abstract class DataEntity {

  /// The id used in the database
  int id;

  /// The name / title of the entity (usually shown the the user)
  String title;

  /// The duration of the entity
  Duration duration = const Duration(milliseconds: 0);

  /// The cache key (if exists) for the picture of this entity
  Uint8List? pictureCacheKey;


  DataEntity({required this.id, required this.title});

  DataEntity.withDuration({required this.id, required this.title, required this.duration});


  /// Returns the EntityType enum for the given entity type
  EntityType get entityType;


  @override
  String toString() {
    return "<$runtimeType $id $title ${formatDuration(duration)}>";
  }
}



/// The Song DataEntity
///
/// Extends the DataEntity class
///
/// Used to represent a song. Contains metadata and
/// file information about the given song, as well as display information
class Song extends DataEntity {

  /// The path to the audio file
  File file;

  /// The metadata embedded inside the file
  Metadata metadata;

  /// If the song is liked
  bool liked = false;

  Song({required super.id, required super.title, required this.file, required this.metadata});

  Song.withDuration({required super.id, required super.title, required super.duration, required this.file, required this.metadata}) :
        super.withDuration();


  String artistAlbumText() {

    List<String> a = [];

    if(metadata.albumName != null) {
      a.add(metadata.albumName!);
    }
    else if(metadata.albumArtistName != null) {
      a.add(metadata.albumArtistName!);
    }

    if(metadata.authorName != null) {
      a.add(metadata.authorName!);
    }
    else if(metadata.trackArtistNames != null) {
      a.add(metadata.trackArtistNames!.join(", "));
    }

    return a.join(" - ");
  }

  @override
  EntityType get entityType => EntityType.song;
}



/// The Playlist DataEntity
///
/// Extends the DataEntity class
///
/// Used to represent a playlist. Contains 0 or more Song
/// entities
class Playlist extends DataEntity {

  /// The songs in this playlist
  List<Song> songs = [];


  Playlist({required super.id, required super.title});

  Playlist.withSongs({required super.id, required super.title, required this.songs}) :
    super.withDuration(duration: songs.isEmpty ? const Duration(milliseconds: 0) : songs.map((e) => e.duration).reduce((value, element) => value + element));

  Playlist.withDuration({required super.id, required super.title, required super.duration}) :
      super.withDuration();


  /// Recalculates the duration of the playlist from the given songs
  void updateDuration(){

    if(songs.isEmpty) {
      super.duration = const Duration(milliseconds: 0);
      return;
    }
    super.duration = songs.map((e) => e.duration).reduce((value, element) => value + element);
  }


  @override
  EntityType get entityType => EntityType.playlist;

  @override
  String toString() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: ${songs.length}>";
  }

  String toStringWithSongs() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: $songs>";
  }
}



/// The Album DataEntity
///
/// Extends the DataEntity class
///
/// Used to represent an album. Contains 0 or more Song
/// entities
class Album extends Playlist {

  Album({required super.id, required super.title});

  Album.withSongs({required super.id, required super.title, required super.songs}) :
        super.withSongs();

  Album.withDuration({required super.id, required super.title, required super.duration}) :
        super.withDuration();

  @override
  EntityType get entityType => EntityType.album;
}



/// Pair generic
class Pair<A, B> {

  final A itemA;
  final B itemB;

  Pair({required this.itemA, required this.itemB});
}



/// Marks some data as selected or not selected
class SelectableDataItem<A> {

  final A item;
  bool isSelected;

  SelectableDataItem(this.item, this.isSelected);
}



/// Contains data for showing a snackbar
class SnackBarData {

  final String text;
  final Duration? duration;
  final Color? color;

  const SnackBarData({required this.text, this.duration, this.color});
}