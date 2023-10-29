


import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../../data/DataEntity.dart';

final class TableSong {

  final int id;
  final String songPath;

  TableSong.privateConstructor({required this.id, required this.songPath});

  static const String name = "tbl_song";
  static const String idCol = "id";
  static const String songPathCol = "song_path";

  static Future<int?> selectId_unchecked(Database db, File path) async {

    var result = await db.query(name, columns: [idCol], where: "$songPathCol = ?", whereArgs: [path.absolute.path]);

    return (result.firstOrNull?[idCol]) as int?;
  }

  static Future<int?> insertSong(File path) async {

    // TODO: optimize this function to use 1 query

    if(!(await path.exists())) {
      logging.warning("Cannot insert song which does not exist");
      return null;
    }

    var db = await DatabaseController.instance.database;

    var existingSongId = await selectId_unchecked(db, path);

    if(existingSongId != null) {

      logging.info("Song with path $path already exists in the database, updating metadata");

      if(!(await TableFMetadata.updateMetadataFor_unchecked(db, existingSongId, path))) {
        logging.warning("Could not update the metadata for song with id $existingSongId");
      }

      return existingSongId;
    }


    var songId = await db.insert( name, { songPathCol : path.absolute.path } );

    if(!await TableFMetadata.insertMetadataFor_unchecked(db, songId, path)) {
      logging.warning("Could not insert the metadata for song with id $songId");
    }

    return songId;
  }

  static Future<List<Song>> selectAllWithMetadata() async {

    var db = await DatabaseController.instance.database;

    const String sql = "SELECT * FROM ${TableSong.name}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
    ;

    var result = await db.rawQuery(sql);
    
    return result.map((e) {

      Metadata m = TableFMetadata.fromMap(e);

      String path = e[TableSong.songPathCol] as String;
      String title = Path.basename(path);
      int duration = 0;

      if(m.trackName != null) {
        title = m.trackName!;
      }

      if(m.trackDuration != null) {
        duration = m.trackDuration!;
      }

      Song s = Song(title: title, duration: Duration(milliseconds: duration), file: File(path), metadata: m);

      return s;
      
    }).toList();
  }

}