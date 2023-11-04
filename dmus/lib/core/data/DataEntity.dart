import 'dart:io';
import 'dart:typed_data';

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


  Song({required super.id, required super.title, required this.file, required this.metadata});

  Song.withDuration({required super.id, required super.title, required super.duration, required this.file, required this.metadata}) :
        super.withDuration();


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
class Album extends DataEntity {

  /// Songs in this album
  List<Song> songs = [];


  Album({required super.id, required super.title});

  Album.withSongs({required super.id, required super.title, required this.songs}) :
        super.withDuration(duration: songs.map((e) => e.duration).reduce((value, element) => value + element));


  @override
  EntityType get entityType => EntityType.album;
}



class SelectableDataItem<A> {

  final A item;
  bool isSelected;

  SelectableDataItem(this.item, this.isSelected);
}