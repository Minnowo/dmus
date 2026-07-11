import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
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

  Future<int> insertAlbumRow(String title) async {
    final db = await DatabaseController.database;
    return await db.insert(TableAlbum.name, {TableAlbum.titleCol: title});
  }

  Future<List<int>> insertSongs(List<String> names) async {
    final ids = <int>[];
    for (final n in names) {
      ids.add((await TableSong.insertSong(await createFakeSongFile(tempDir, n)))!);
    }
    return ids;
  }

  Future<List<Song>> songsFor(List<int> ids) async {
    return [for (final id in ids) (await TableSong.selectFromId(id))!];
  }

  Future<List<Map<String, Object?>>> songRowsFor(int albumId) async {
    final db = await DatabaseController.database;
    return db.query(TableAlbumSong.name,
        where: '${TableAlbumSong.albumIdCol} = ?', whereArgs: [albumId], orderBy: TableAlbumSong.songIndexCol);
  }

  group('TableAlbumSong.setSongsInAlbum', () {
    test('inserts the songs in order', () async {
      final albumId = await insertAlbumRow('My Album');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      await TableAlbumSong.setSongsInAlbum(albumId, await songsFor(songIds));

      final rows = await songRowsFor(albumId);

      expect(rows.map((e) => e[TableAlbumSong.songIdCol]), songIds);
      expect(rows.map((e) => e[TableAlbumSong.songIndexCol]), [0, 1]);
    });

    test('replaces the previous song list rather than appending', () async {
      final albumId = await insertAlbumRow('My Album');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      final songs = await songsFor(songIds);

      await TableAlbumSong.setSongsInAlbum(albumId, songs);
      await TableAlbumSong.setSongsInAlbum(albumId, [songs[1]]);

      final rows = await songRowsFor(albumId);

      expect(rows.map((e) => e[TableAlbumSong.songIdCol]), [songIds[1]]);
    });

    test('an empty list clears the album', () async {
      final albumId = await insertAlbumRow('My Album');
      final songIds = await insertSongs(['a.mp3']);

      await TableAlbumSong.setSongsInAlbum(albumId, await songsFor(songIds));
      await TableAlbumSong.setSongsInAlbum(albumId, []);

      expect(await songRowsFor(albumId), isEmpty);
    });
  });

  group('TableAlbumSong.setSongsInAlbumTx', () {
    test('can be used as part of a caller-provided transaction', () async {
      final albumId = await insertAlbumRow('My Album');
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      final songs = await songsFor(songIds);

      final db = await DatabaseController.database;
      await db.transaction((txn) => TableAlbumSong.setSongsInAlbumTx(txn, albumId, songs));

      final rows = await songRowsFor(albumId);

      expect(rows.map((e) => e[TableAlbumSong.songIdCol]), songIds);
    });
  });
}
