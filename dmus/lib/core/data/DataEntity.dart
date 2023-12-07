import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import '../Util.dart';


const String DEFAULT_SEP = "  ";

/// Enum used to quickly determine which type of entity
/// a given DataEntity is
enum EntityType {
  song,
  playlist,
  album
}

/// Song sorts orders
enum SongSort {
  byId,
  byTitle,
  byArtist,
  byAlbum,
  byDuration,
  byRandom,
}


/// Playlist sorts orders
enum PlaylistSort {
  byId,
  byTitle,
  byDuration,
  byNumberOfTracks,
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
  Uint8List? get pictureCacheKey => _pictureCacheKey;

  Uint8List? _pictureCacheKey;

  File? artPath;


  DataEntity({required this.id, required this.title});

  DataEntity.withDuration({required this.id, required this.title, required this.duration});


  /// Returns the EntityType enum for the given entity type
  EntityType get entityType;


  /// Sets the picture cache key of this item
  ///
  /// This also will fetch the file path of the cached item if possible
  Future<void> setPictureCacheKey(Uint8List? pictureCacheKey) async {
    _pictureCacheKey = pictureCacheKey;

    if(pictureCacheKey != null) {
      artPath =  await ImageCacheController.getImagePathFromRaw(pictureCacheKey);
    }
  }

  /// Returns basic info text about the entity
  String basicInfoText();

  /// Returns basic info text about the entity with the given separator
  String basicInfoTextWithSep(String sep);

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



  @override
  EntityType get entityType => EntityType.song;


  @override
  String basicInfoTextWithSep(String sep) {
    return [
      formatDuration(duration),

      if(metadata.discNumber != null)
        "Disc ${metadata.discNumber}",

      if(metadata.trackNumber != null)
        "Track ${metadata.trackNumber}",

    ].join(sep);
  }

  @override
  String basicInfoText() => basicInfoTextWithSep(DEFAULT_SEP);

  MediaItem toMediaItem(){
    return MediaItem(
        id: file.path,
        title: title,
      duration: duration,
      artist: metadata.authorName ?? metadata.trackArtistNames?.join(", ") ?? metadata.albumArtistName,
      album: metadata.albumName,
      artUri: artPath != null ? Uri.file(artPath!.path) : null,
    );
  }


  String songArtist() {
    return metadata.authorName ?? metadata.trackArtistNames?.join(", ") ?? LocalizationMapper.current.nA;
  }

  String songAlbum() {
    return metadata.albumName ?? LocalizationMapper.current.nA;
  }

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
  int get hashCode => id;

  @override
  bool operator ==(Object other) {
    return other is Song && (other).id == id;
  }
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
    super.withDuration(duration: songs.isEmpty ? Duration.zero : songs.map((e) => e.duration).reduce((value, element) => value + element));

  Playlist.withDuration({required super.id, required super.title, required super.duration}) :
      super.withDuration();


  /// Recalculates the duration of the playlist from the given songs
  void updateDuration(){

    if(songs.isEmpty) {
      super.duration = const Duration(milliseconds: 0);
      return;
    }
    super.duration = songs.map((e) => e.duration).reduce(sumDuration);
  }

  Future<void> updatePicture() async {
    if(songs.isEmpty) {
      super._pictureCacheKey = null;
      artPath = null;
      return;
    }

    for(final i in songs) {

      if(i.pictureCacheKey != null && pictureCacheKey != i.pictureCacheKey) {
        artPath = null;
        super._pictureCacheKey = null;
        await super.setPictureCacheKey(i.pictureCacheKey);
        return;
      }
    }

    super._pictureCacheKey = null;
    artPath = null;
  }

  @override
  Future<void> setPictureCacheKey(Uint8List? pictureCacheKey) async {

    if(pictureCacheKey != null) {
      await super.setPictureCacheKey(pictureCacheKey);
      return;
    }

    if(this.pictureCacheKey != null) {
      await updatePicture();
      return;
    }

    for(final i in songs) {

      if(i.pictureCacheKey != null) {
        await super.setPictureCacheKey(i.pictureCacheKey);
        return;
      }
    }
  }

  @override
  EntityType get entityType => EntityType.playlist;

  @override
  String basicInfoTextWithSep(String sep){
    return [
      formatDuration(duration),
      "${songs.length} songs",
    ].join(sep);
  }

  @override
  String basicInfoText() => basicInfoTextWithSep(DEFAULT_SEP);

  @override
  String toString() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: ${songs.length}>";
  }

  void addSong(Song s) {
    duration += s.duration;
    songs.add(s);
  }

  void addSongs(Iterable<Song> s) {
    songs.addAll(s.map((e) { duration += e.duration; return e;}));
  }

  Song? removeSongAt(int i) {
    if(i < 0 || i >= songs.length) return null;
    Song s = songs.removeAt(i);
    duration -= s.duration;
    return s;
  }

  void removeAllOfSongId(int id) {
    songs.removeWhere((e) => e.id == id);
    updateDuration();
  }

  void removeSong(Song s) {
    if(songs.remove(s)) {
      duration -= s.duration;
    }
  }

  String toStringWithSongs() {
    return "<$runtimeType $id $title ${formatDuration(duration)} songs: $songs>";
  }

  int songsHashCode(){
    return songs.hashCode;
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
  bool isVisible;

  SelectableDataItem(this.item, this.isSelected, this.isVisible);
}



/// Contains data for showing a snackbar
class SnackBarData {

  final String text;
  final Duration? duration;
  final Color? color;

  static const Duration defaultDuration = Duration(milliseconds: 1500);

  const SnackBarData({required this.text, this.duration=defaultDuration, this.color});
}