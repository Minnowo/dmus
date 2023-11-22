


import 'package:dmus/core/data/MyDataEntityCache.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';

import '../../data/DataEntity.dart';

final class TableLikes {

  final int songId;

  TableLikes.privateConstructor({required this.songId});

  static const String name = "tbl_likes";
  static const String songIdCol = "song_id";

  static Playlist? likedPlaylist;

  static Future<void> reGenerateLikedPlaylist() async {

    final db = await DatabaseController.database;

    await db.delete(TablePlaylist.name, where: "${TablePlaylist.idCol} = ${TablePlaylist.likedPlaylistId}");

    await TablePlaylist.generateLikesPlaylist();

    final results = await db.query(name);

    await TablePlaylistSong.setSongsInPlaylistJustId(TablePlaylist.likedPlaylistId, results.map((e) => e[songIdCol] as int).toList());

    Playlist p = Playlist(id: TablePlaylist.likedPlaylistId, title: TablePlaylist.likedPlaylistName);

    p.songs.addAll(await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId));

    p.updateDuration();

    likedPlaylist = p;
  }

  static Future<void> markSongLiked(Song song) async {

    final db = await DatabaseController.database;

    await db.rawInsert("INSERT OR IGNORE INTO $name ($songIdCol) VALUES (?)", [song.id]);

    await TablePlaylist.generateLikesPlaylist();
    await TablePlaylistSong.appendSongToPlaylist(TablePlaylist.likedPlaylistId, song.id);

    if(likedPlaylist == null){
      await reGenerateLikedPlaylist();
    } else {
      likedPlaylist!.songs.add(song);
      ImportController.pubLikedPlaylistUpdated(likedPlaylist!);
    }
  }

  static Future<void> markSongNotLiked(Song song) async {

    final db = await DatabaseController.database;

    await db.delete(name, where: "$songIdCol = ?", whereArgs: [song.id]);

    await TablePlaylist.generateLikesPlaylist();
    await TablePlaylistSong.removeSongFromPlaylist(TablePlaylist.likedPlaylistId, song.id);

    if(likedPlaylist == null){
      await reGenerateLikedPlaylist();
    } else {
      likedPlaylist!.songs.removeWhere((e) => e.id == song.id);
      ImportController.pubLikedPlaylistUpdated(likedPlaylist!);
    }
  }

  static Future<bool> isSongLiked(int songId) async {

    final db = await DatabaseController.database;

    return (await db.query(name, where: "$songIdCol = ?", whereArgs: [songId])).isNotEmpty;
  }
}