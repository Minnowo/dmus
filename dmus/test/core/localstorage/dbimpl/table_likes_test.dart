import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylistSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_helpers.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  Future<Song> insertSong(String fileName) async {
    final id = (await TableSong.insertSong(await createFakeSongFile(tempDir, fileName)))!;
    return (await TableSong.selectFromId(id))!;
  }

  group('TableLikes.markSongLiked', () {
    test('marks the song liked in tbl_likes', () async {
      final song = await insertSong('a.mp3');

      await TableLikes.markSongLiked(song);

      expect(await TableLikes.isSongLiked(song.id), isTrue);
    });

    test('adds the song to the Favorites playlist', () async {
      final song = await insertSong('a.mp3');

      await TableLikes.markSongLiked(song);

      final favoriteSongs = await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId);

      expect(favoriteSongs.map((e) => e.id), contains(song.id));
    });

    test('populates TableLikes.likedPlaylist when it was not already cached', () async {
      final song = await insertSong('a.mp3');
      expect(TableLikes.likedPlaylist, isNull);

      await TableLikes.markSongLiked(song);

      expect(TableLikes.likedPlaylist, isNotNull);
      expect(TableLikes.likedPlaylist!.songs.map((e) => e.id), contains(song.id));
    });

    test('appends to the already-cached likedPlaylist rather than rebuilding it', () async {
      final songA = await insertSong('a.mp3');
      final songB = await insertSong('b.mp3');

      await TableLikes.markSongLiked(songA);
      final cachedPlaylist = TableLikes.likedPlaylist;

      await TableLikes.markSongLiked(songB);

      expect(TableLikes.likedPlaylist, same(cachedPlaylist));
      expect(TableLikes.likedPlaylist!.songs.map((e) => e.id), containsAll([songA.id, songB.id]));
    });
  });

  group('TableLikes.markSongNotLiked', () {
    test('unmarks the song in tbl_likes', () async {
      final song = await insertSong('a.mp3');
      await TableLikes.markSongLiked(song);

      await TableLikes.markSongNotLiked(song);

      expect(await TableLikes.isSongLiked(song.id), isFalse);
    });

    test('removes the song from the Favorites playlist', () async {
      final song = await insertSong('a.mp3');
      await TableLikes.markSongLiked(song);

      await TableLikes.markSongNotLiked(song);

      final favoriteSongs = await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId);

      expect(favoriteSongs.map((e) => e.id), isNot(contains(song.id)));
    });

    test('removes the song from the cached likedPlaylist', () async {
      final song = await insertSong('a.mp3');
      await TableLikes.markSongLiked(song);

      await TableLikes.markSongNotLiked(song);

      expect(TableLikes.likedPlaylist!.songs.map((e) => e.id), isNot(contains(song.id)));
    });

    test('unliking a song that was never liked does not throw', () async {
      final song = await insertSong('a.mp3');

      await TableLikes.markSongNotLiked(song);

      expect(await TableLikes.isSongLiked(song.id), isFalse);
    });
  });

  group('TableLikes.isSongLiked', () {
    test('returns false for a song that was never liked', () async {
      final song = await insertSong('a.mp3');

      expect(await TableLikes.isSongLiked(song.id), isFalse);
    });

    test('returns true only for the specific song that was liked', () async {
      final likedSong = await insertSong('a.mp3');
      final otherSong = await insertSong('b.mp3');

      await TableLikes.markSongLiked(likedSong);

      expect(await TableLikes.isSongLiked(likedSong.id), isTrue);
      expect(await TableLikes.isSongLiked(otherSong.id), isFalse);
    });
  });

  group('TableLikes.reGenerateLikedPlaylist', () {
    test('rebuilds likedPlaylist from tbl_likes contents', () async {
      final song = await insertSong('a.mp3');
      final db = await DatabaseController.database;
      await db.rawInsert('INSERT INTO ${TableLikes.name} (${TableLikes.songIdCol}) VALUES (?)', [song.id]);

      await TableLikes.reGenerateLikedPlaylist();

      expect(TableLikes.likedPlaylist, isNotNull);
      expect(TableLikes.likedPlaylist!.songs.map((e) => e.id), [song.id]);

      final favoriteSongs = await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId);
      expect(favoriteSongs.map((e) => e.id), [song.id]);
    });

    test('treats tbl_likes as authoritative, dropping Favorites playlist entries not backed by it', () async {
      // Simulate a song that ended up in the Favorites playlist without a
      // corresponding tbl_likes row (e.g. added through a path that only
      // touches the playlist, bypassing TableLikes).
      final orphanSong = await insertSong('orphan.mp3');
      await TablePlaylist.generateLikesPlaylist();
      final db = await DatabaseController.database;
      await db.insert(TablePlaylistSong.name, {
        TablePlaylistSong.playlistIdCol: TablePlaylist.likedPlaylistId,
        TablePlaylistSong.songIdCol: orphanSong.id,
        TablePlaylistSong.songIndexCol: 0,
      });

      await TableLikes.reGenerateLikedPlaylist();

      final favoriteSongs = await TablePlaylist.selectPlaylistSongs(TablePlaylist.likedPlaylistId);
      expect(favoriteSongs.map((e) => e.id), isNot(contains(orphanSong.id)));
    });

    test('results in an empty Favorites playlist when tbl_likes is empty', () async {
      await insertSong('a.mp3');

      await TableLikes.reGenerateLikedPlaylist();

      expect(TableLikes.likedPlaylist!.songs, isEmpty);
    });
  });
}
