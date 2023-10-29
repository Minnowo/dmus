


import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path/path.dart' as Path;
import 'package:crypto/crypto.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:dmus/core/localstorage/dbimpl/TableHash.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../../data/DataEntity.dart';

final class TableSong {

  final int id;
  final String songPath;

  TableSong.privateConstructor({required this.id, required this.songPath});

  static const String name = "tbl_song";
  static const String hashIdCol = "hash_id";
  static const String songPathCol = "song_path";

  static Future<int?> insertSong(File path) async {

    // TODO: optimize this function to use 1 query

    if(!(await path.exists())) {
      logging.warning("Cannot insert song which does not exist");
      return null;
    }

    var db = await DatabaseController.instance.database;

    var digest = await sha256.bind(path.openRead()).first;

    var hashId = await TableHash.insertHash(digest);

    if(hashId == null) {
      logging.severe("Failed to get a hash from the digest of $digest");
      return null;
    }

    await TableFMetadata.insertMetadataFor_unchecked(hashId, path);

    logging.info("Inserting song $path with hash_id $hashId");

    try {

      return await db.insert(
          name,
          {
            hashIdCol: hashId,
            songPathCol : path.absolute.path
          }
      );
    }
    catch(e) {

      if(e is! DatabaseException) {
        rethrow;
      }
    }

    return null;
  }

  static Future<List<TableSong>> selectAll() async {

    logging.finest("Selecting all songs from the $name table");

    var db = await DatabaseController.instance.database;

    var result = await db.query( name );

    return  result.map((e) => TableSong.privateConstructor(id: e[hashIdCol] as int, songPath: e[songPathCol] as String )).toList();
  }


  static Future<List<Song>> selectAllWithMetadata() async {

    var db = await DatabaseController.instance.database;

    const String sql = "SELECT * FROM ${TableHash.name}"
        " JOIN ${TableFMetadata.name} ON ${TableHash.name}.${TableHash.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " JOIN ${TableSong.name} ON ${TableHash.name}.${TableHash.idCol} = ${TableSong.name}.${TableSong.hashIdCol}"
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