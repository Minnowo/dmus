import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';

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
  static const String discNumberCol = "disc_number";
  static const String yearCol = "year";
  static const String durationMsCol = "duration_ms";
  static const String trackArtistJoinValue = "\$;\$;";

  static Future<bool> updateMetadataFor_unchecked(Database db, int songId, File file) async {

    logging.info("Updating metadata for $file with id $songId");

    Metadata m = await MetadataRetriever.fromFile(file);

    try{

      await db.update(name, {
        titleCol: m.trackName,
        albumCol: m.albumName,
        albumArtistCol: m.albumArtistName,
        trackArtistCol: m.trackArtistNames?.join(trackArtistJoinValue),
        genreCol: m.genre,
        mimetypeCol: m.mimeType,
        bitrateCol: m.bitrate,
        discNumberCol: m.discNumber,
        yearCol: m.year,
        durationMsCol: m.trackDuration
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

  static Future<bool> insertMetadataFor_unchecked(Database db, int songId, File file) async {

    logging.info("Inserting metadata for $file with id $songId");

    Metadata m = await MetadataRetriever.fromFile(file);

    var db = await DatabaseController.instance.database;

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
        discNumberCol: m.discNumber,
        yearCol: m.year,
        durationMsCol: m.trackDuration
      });
      return true;
    }
    catch(e){
      // ignore duplicate key errors
    }

    return false;
  }


  static Metadata fromMap(Map<String, Object?> e) {

    return Metadata(
        trackName: e[titleCol] as String?,
        albumName: e[albumCol] as String?,
        albumArtistName: e[albumArtistCol] as String?,
        trackArtistNames: (e[trackArtistCol] as String?)?.split(trackArtistJoinValue),
        genre: e[genreCol] as String?,
        mimeType: e[mimetypeCol] as String?,
        bitrate: e[bitrateCol] as int?,
        discNumber: e[discNumberCol] as int?,
        year: e[yearCol] as int?,
        trackDuration: e[durationMsCol] as int?
    );
  }
}