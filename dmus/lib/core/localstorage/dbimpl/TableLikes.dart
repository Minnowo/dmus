import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';

import '../../data/DataEntity.dart';

final class TableLikes {
  final int songId;

  TableLikes.privateConstructor({required this.songId});

  static const String name = "tbl_likes";
  static const String songIdCol = "song_id";

  static Playlist? likedPlaylist;

  static Future<void> reGenerateLikedPlaylist() async {
    final db = await DatabaseController.database;

    List<int> likedSongIds = [];

    await db.transaction((txn) async {
      await txn.delete(TablePlaylist.name, where: "${TablePlaylist.idCol} = ${TablePlaylist.likedPlaylistId}");

      await TablePlaylist.generateLikesPlaylistTx(txn);

      final results = await txn.query(name);
      likedSongIds = results.map((e) => e[songIdCol] as int).toList();

      await TablePlaylistSong.setSongsInPlaylistJustIdTx(txn, TablePlaylist.likedPlaylistId, likedSongIds);
    });

    Playlist p = Playlist(id: TablePlaylist.likedPlaylistId, title: TablePlaylist.likedPlaylistName);

    p.addSongs(await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId));
    await p.setPictureCacheKey(null);

    likedPlaylist = p;
  }

  static Future<void> markSongLiked(Song song) async {
    final db = await DatabaseController.database;

    await db.transaction((txn) async {
      await txn.rawInsert("INSERT OR IGNORE INTO $name ($songIdCol) VALUES (?)", [song.id]);

      await TablePlaylist.generateLikesPlaylistTx(txn);
      await TablePlaylistSong.appendSongToPlaylistTx(txn, TablePlaylist.likedPlaylistId, song.id);
    });

    if (likedPlaylist == null) {
      await reGenerateLikedPlaylist();
    } else {
      likedPlaylist!.addSong(song);
      await likedPlaylist!.setPictureCacheKey(null);
      ImportController.pubLikedPlaylistUpdated(likedPlaylist!);
    }
  }

  static Future<void> markSongNotLiked(Song song) async {
    final db = await DatabaseController.database;

    await db.transaction((txn) async {
      await txn.delete(name, where: "$songIdCol = ?", whereArgs: [song.id]);

      await TablePlaylist.generateLikesPlaylistTx(txn);
      await TablePlaylistSong.removeSongFromPlaylistTx(txn, TablePlaylist.likedPlaylistId, song.id);
    });

    if (likedPlaylist == null) {
      await reGenerateLikedPlaylist();
    } else {
      likedPlaylist!.removeAllOfSongId(song.id);
      await likedPlaylist!.setPictureCacheKey(null);
      ImportController.pubLikedPlaylistUpdated(likedPlaylist!);
    }
  }

  static Future<bool> isSongLiked(int songId) async {
    final db = await DatabaseController.database;

    return (await db.query(name, where: "$songIdCol = ?", whereArgs: [songId])).isNotEmpty;
  }
}
