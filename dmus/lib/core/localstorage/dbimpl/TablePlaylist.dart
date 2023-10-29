


import 'dart:math';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:sqflite/sqflite.dart';

import '../../Util.dart';
import '../../data/DataEntity.dart';
import 'TableFMetadata.dart';

final class TablePlaylist {

  final int id;
  final String title;

  TablePlaylist.privateConstructor({required this.id, required this.title});

  static const String name = "tbl_playlist";
  static const String idCol = "id";
  static const String titleCol = "title";

  static Future<bool> createPlaylist(String title, List<Song> songs) async {

    if(title.isEmpty) {
      logging.warning("Cannot insert playlist with title $title because it is empty");
      return false;
    }

    logging.finest("Creating playlist with title: $title and songs $songs");

    var db = await DatabaseController.instance.database;

    var playlistId = await db.insert(name, { titleCol: title });

    TablePlaylistSong.addSongsToPlaylist(playlistId, songs);

    return true;
  }


  static Future<Iterable<Song>> getPlaylistSongs(int playlistId) async {

    var db = await DatabaseController.instance.database;

    const String sql = "SELECT * FROM ${TablePlaylistSong.name}"
        " JOIN ${TableSong.name} ON ${TablePlaylistSong.name}.${TablePlaylistSong.songIdCol} = ${TableSong.name}.${TableSong.idCol}"
        " JOIN ${TableFMetadata.name} ON ${TableSong.name}.${TableSong.idCol} = ${TableFMetadata.name}.${TableFMetadata.idCol}"
        " WHERE ${TablePlaylistSong.name}.${TablePlaylistSong.playlistIdCol} = ?";
    ;

    var result = await db.rawQuery(sql, [playlistId]);

    return result.map((e) => TableSong.fromMappedObjects(e));
  }


  static Future<List<Playlist>> selectAll() async {

    var db = await DatabaseController.instance.database;

    var playlistsReult = await db.query(TablePlaylist.name);

    List<Playlist> playlists = [];

    for(var e in playlistsReult) {

      int id = e[TablePlaylist.idCol] as int;

      Playlist p = Playlist(id: id, title: e[TablePlaylist.titleCol] as String);

      p.songs.addAll(await getPlaylistSongs(id));

      p.updateDuration();

      playlists.add(p);
    }

    return playlists;
  }
}