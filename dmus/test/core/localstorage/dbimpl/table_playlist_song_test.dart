import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
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

  Future<int> insertPlaylistRow(String title) async {
    final db = await DatabaseController.database;
    return await db.insert(TablePlaylist.name, {TablePlaylist.titleCol: title});
  }

  Future<List<int>> insertSongs(List<String> names) async {
    final ids = <int>[];
    for (final n in names) {
      ids.add((await TableSong.insertSong(await createFakeSongFile(tempDir, n)))!);
    }
    return ids;
  }

  Future<List<Map<String, Object?>>> songRowsFor(int playlistId) async {
    final db = await DatabaseController.database;
    return db.query(TablePlaylistSong.name,
        where: '${TablePlaylistSong.playlistIdCol} = ?', whereArgs: [playlistId], orderBy: TablePlaylistSong.songIndexCol);
  }

  group('TablePlaylistSong.setSongsInPlaylistJustId', () {
    test('inserts the songs in order', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, songIds);

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), songIds);
      expect(rows.map((e) => e[TablePlaylistSong.songIndexCol]), [0, 1]);
    });

    test('replaces the previous song list rather than appending', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3', 'c.mp3']);

      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, [songIds[0], songIds[1]]);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, [songIds[2]]);

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), [songIds[2]]);
    });

    test('an empty list clears the playlist', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3']);

      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, songIds);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, []);

      expect(await songRowsFor(playlistId), isEmpty);
    });
  });

  group('TablePlaylistSong.setSongsInPlaylistJustIdTx', () {
    test('can be used as part of a caller-provided transaction', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      final db = await DatabaseController.database;
      await db.transaction((txn) => TablePlaylistSong.setSongsInPlaylistJustIdTx(txn, playlistId, songIds));

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), songIds);
    });
  });

  group('TablePlaylistSong.setSongsInPlaylist / setSongsInPlaylistTx', () {
    test('accepts Song objects and stores their ids', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      final songs = [for (final id in songIds) (await TableSong.selectFromId(id))!];

      await TablePlaylistSong.setSongsInPlaylist(playlistId, songs);

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), songIds);
    });

    test('the Tx variant works inside a caller-provided transaction', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3']);
      final songs = [(await TableSong.selectFromId(songIds.single))!];

      final db = await DatabaseController.database;
      await db.transaction((txn) => TablePlaylistSong.setSongsInPlaylistTx(txn, playlistId, songs));

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), songIds);
    });
  });

  group('TablePlaylistSong.removeSongFromPlaylist', () {
    test('removes only the given song, keeping the rest', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, songIds);

      await TablePlaylistSong.removeSongFromPlaylist(playlistId, songIds[0]);

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), [songIds[1]]);
    });

    test('removing a song not in the playlist is a no-op', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3']);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, songIds);

      await TablePlaylistSong.removeSongFromPlaylist(playlistId, 999999);

      final rows = await songRowsFor(playlistId);

      expect(rows, hasLength(1));
    });
  });

  group('TablePlaylistSong.appendSongToPlaylist', () {
    test('appends to an empty playlist at index 0', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3']);

      await TablePlaylistSong.appendSongToPlaylist(playlistId, songIds.single);

      final rows = await songRowsFor(playlistId);

      expect(rows.single[TablePlaylistSong.songIndexCol], 0);
    });

    test('appends after the current last song, not at index 0', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3', 'c.mp3']);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, [songIds[0], songIds[1]]);

      await TablePlaylistSong.appendSongToPlaylist(playlistId, songIds[2]);

      final rows = await songRowsFor(playlistId);

      expect(rows.map((e) => e[TablePlaylistSong.songIdCol]), songIds);
      expect(rows.last[TablePlaylistSong.songIndexCol], 2);
    });
  });

  group('TablePlaylistSong.appendSongToPlaylistTx', () {
    test('can be used as part of a caller-provided transaction', () async {
      final playlistId = await insertPlaylistRow('My Playlist');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      await TablePlaylistSong.setSongsInPlaylistJustId(playlistId, [songIds[0]]);

      final db = await DatabaseController.database;
      await db.transaction((txn) => TablePlaylistSong.appendSongToPlaylistTx(txn, playlistId, songIds[1]));

      final rows = await songRowsFor(playlistId);

      expect(rows.last[TablePlaylistSong.songIdCol], songIds[1]);
      expect(rows.last[TablePlaylistSong.songIndexCol], 1);
    });
  });
}
