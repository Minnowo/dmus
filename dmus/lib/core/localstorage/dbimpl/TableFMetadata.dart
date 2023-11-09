
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as Path;
import '../../Util.dart';



/// Represents tbl_fmetadata in the database
///
/// Contains methods for reading and writing from this table, as well as column information
final class TableFMetadata {

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

    Metadata m = await MetadataRetriever.fromFile(file);

    Digest? cacheKey;

    if(m.albumArt != null) {
      cacheKey = await ImageCacheController.cacheMemoryImage(m.albumArt!);
    }

    try{

      await db.update(name, {
        titleCol: m.trackName,
        albumCol: m.albumName,
        albumArtistCol: m.albumArtistName,
        trackArtistCol: m.trackArtistNames?.join(trackArtistJoinValue),
        genreCol: m.genre,
        mimetypeCol: m.mimeType,
        bitrateCol: m.bitrate,
        trackNumberCol: m.trackNumber,
        discNumberCol: m.discNumber,
        yearCol: m.year,
        durationMsCol: m.trackDuration,
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

    Metadata m = await MetadataRetriever.fromFile(file);

    Digest? cacheKey;

    if(m.albumArt != null) {
      cacheKey = await ImageCacheController.cacheMemoryImage(m.albumArt!);
    } else {

      // TODO: Fix this when we figure out a way to get around the file picker copying literally every file
      // cacheKey = await ImageCacheController.findAndCacheCoverFromDirectory(file.parent);
    }

    var db = await DatabaseController.database;

    try{

      await db.insert(name,{
        idCol: songId,
        titleCol: m.trackName,
        albumCol: m.albumName,
        albumArtistCol: m.albumArtistName,
        trackArtistCol: m.trackArtistNames?.join(trackArtistJoinValue),
        genreCol: m.genre,
        mimetypeCol: m.mimeType,
        bitrateCol: m.bitrate,
        trackNumberCol: m.trackNumber,
        discNumberCol: m.discNumber,
        yearCol: m.year,
        durationMsCol: m.trackDuration,
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
  static Metadata fromMap(Map<String, Object?> e) {

    return Metadata(
        trackName: e[titleCol] as String?,
        albumName: e[albumCol] as String?,
        albumArtistName: e[albumArtistCol] as String?,
        trackArtistNames: (e[trackArtistCol] as String?)?.split(trackArtistJoinValue),
        genre: e[genreCol] as String?,
        mimeType: e[mimetypeCol] as String?,
        bitrate: e[bitrateCol] as int?,
        trackNumber: e[trackNumberCol] as int?,
        discNumber: e[discNumberCol] as int?,
        year: e[yearCol] as int?,
        trackDuration: e[durationMsCol] as int?
    );
  }
}
