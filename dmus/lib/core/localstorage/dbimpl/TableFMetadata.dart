
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:crypto/crypto.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';



/// Represents tbl_fmetadata in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableFMetadata {

  static const String GENRE_JOIN = "`&\$";

  final int id;
  final String? title;
  final String? album;
  final String? albumArist;
  final String? trackArist;
  final String? genre;
  final String? mimetype;
  final int? bitrate;
  final int? discNumber;
  final int? year;
  final int? durationMs;

  TableFMetadata.privateConstructor({
    required this.title,
    required this.album,
    required this.albumArist,
    required this.trackArist,
    required this.genre,
    required this.mimetype,
    required this.bitrate,
    required this.discNumber,
    required this.year,
    required this.durationMs,
    required this.id});

  static const String name = "tbl_fmetadata";
  static const String idCol = "song_id";
  static const String titleCol= "title";
  static const String albumCol = "album";
  static const String albumArtistCol = "album_artist";
  static const String trackArtistCol = "track_artist";
  static const String genreCol = "genre";
  static const String mimetypeCol = "mimetype";
  static const String bitrateCol = "bitrate";
  static const String trackNumberCol = "track_number";
  static const String discNumberCol = "disc_number";
  static const String yearCol = "year";
  static const String durationMsCol = "duration_ms";
  static const String artCacheKeyCol = "art_cache_key";

  /// Joins the track artists with this value before inserting into the database
  static const String trackArtistJoinValue = "\$;\$;";

  
  /// Updates the given metadata for the given songId
  ///
  /// Does not check if the file exists
  ///
  /// Caches the songs embedded picture if exists
  static Future<bool> updateSongMetadataUnchecked(Database db, int songId, File file) async {

    logging.info("Updating metadata for $file with id $songId");

    AudioMetadata m;
    try {
      m = readMetadata(file, getImage: true);
    } on (MetadataParserException, NoMetadataParserException) {
      m = AudioMetadata(file: file, title: Path.basename(file.path));
    }

    Digest? cacheKey;

    if(m.pictures.isNotEmpty) {
      cacheKey = await ImageCacheController.cacheMemoryImage(m.pictures.first.bytes!);
    } else {
      cacheKey = await ImageCacheController.findAndCacheCoverFromDirectory(file.parent);
    }

    try{

      await db.update(name, {
        titleCol: m.title ?? Path.basename(file.path),
        albumCol: m.album,
        albumArtistCol: m.artist,
        trackArtistCol: "",
        genreCol: m.genres.join(GENRE_JOIN),
        mimetypeCol: "",
        bitrateCol: m.bitrate,
        trackNumberCol: m.trackNumber,
        discNumberCol: m.discNumber,
        yearCol: m.year?.year ?? 0,
        durationMsCol: m.duration?.inMilliseconds ?? 0,
        artCacheKeyCol: cacheKey?.bytes
      },
          where: "$idCol = ?",
          whereArgs: [songId]
      );
      return true;
    }
    catch(e){
      // ignore duplicate key errors
    }

    return false;
  }


  /// Insert the metadata for the given songId
  ///
  /// Does not check if the file exists
  ///
  /// Caches the songs embedded picture if exists
  static Future<bool> insertSongMetadataUnchecked(Database db, int songId, File file) async {

    logging.info("Inserting metadata for $file with id $songId");

    AudioMetadata m;
    try {
      m = readMetadata(file, getImage: true);
    } on (MetadataParserException, NoMetadataParserException) {
      m = AudioMetadata(file: file, title: Path.basename(file.path));
    }

    Digest? cacheKey;

    if(m.pictures.isNotEmpty) {
      cacheKey = await ImageCacheController.cacheMemoryImage(m.pictures.first.bytes);
    } else {
      cacheKey = await ImageCacheController.findAndCacheCoverFromDirectory(file.parent);
    }

    var db = await DatabaseController.database;

    try{

      await db.insert(name,{
        idCol: songId,
        titleCol: m.title ?? Path.basename(file.path),
        albumCol: m.album,
        albumArtistCol: m.artist,
        trackArtistCol: "",
        genreCol: m.genres.join(GENRE_JOIN),
        mimetypeCol: "",
        bitrateCol: m.bitrate,
        trackNumberCol: m.trackNumber,
        discNumberCol: m.discNumber,
        yearCol: m.year?.year ?? 0,
        durationMsCol: m.duration?.inMilliseconds ?? 0,
        artCacheKeyCol: cacheKey?.bytes
      });
      return true;
    }
    catch(e){
      // ignore duplicate key errors
    }

    return false;
  }


  /// Returns a Metadata object from a map going from column names to their datatype
  ///
  /// This does not include the artCacheKeyCol column
  static AudioMetadata fromMap(Map<String, Object?> e) {

    var a = AudioMetadata(
      file: File("NULL"),
        title: e[titleCol] as String?,
        album: e[albumCol] as String?,
        artist: e[albumArtistCol] as String?,
        bitrate: e[bitrateCol] as int?,
        trackNumber: e[trackNumberCol] as int?,
        discNumber: e[discNumberCol] as int?,
        year: DateTime(e[yearCol] as int? ?? 0),
        duration:Duration(milliseconds: e[durationMsCol] as int? ?? 0)
    );

    if(e.containsKey(genreCol)){

      List<String> g = (e[genreCol] as String?)?.split(GENRE_JOIN) ?? [];

      a.genres.addAll(g);
    }
    return a;
  }
}
