import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableArtist.dart';
import 'package:dmus/core/localstorage/dbimpl/TableArtistSong.dart';
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

  Future<int> insertArtistRow(String title) async {
    final db = await DatabaseController.database;
    return await db.insert(TableArtist.name, {TableArtist.titleCol: title});
  }

  /// Inserts a real song row (to satisfy the foreign key) but returns an
  /// in-memory Song with a chosen album, so songAlbum()'s value is under
  /// the test's control rather than depending on fallback metadata.
  Future<Song> insertSongWithAlbum(String fileName, String? album) async {
    final file = await createFakeSongFile(tempDir, fileName);
    final songId = (await TableSong.insertSong(file))!;
    return Song(id: songId, title: fileName, file: file, metadata: AudioMetadata(file: file, album: album));
  }

  Future<List<Map<String, Object?>>> songRowsFor(int artistId) async {
    final db = await DatabaseController.database;
    return db.query(TableArtistSong.name,
        where: '${TableArtistSong.artistIdCol} = ?', whereArgs: [artistId], orderBy: TableArtistSong.songIndexCol);
  }

  group('TableArtistSong.setSongsInArtist', () {
    test('inserts the songs in order with their album recorded', () async {
      final artistId = await insertArtistRow('My Artist');
      final songA = await insertSongWithAlbum('a.mp3', 'Album A');
      final songB = await insertSongWithAlbum('b.mp3', 'Album B');

      await TableArtistSong.setSongsInArtist(artistId, [songA, songB]);

      final rows = await songRowsFor(artistId);

      expect(rows.map((e) => e[TableArtistSong.songIdCol]), [songA.id, songB.id]);
      expect(rows.map((e) => e[TableArtistSong.songIndexCol]), [0, 1]);
      expect(rows.map((e) => e[TableArtistSong.songAlbumCol]), ['Album A', 'Album B']);
    });

    test('falls back to a localized N/A when the song has no album', () async {
      final artistId = await insertArtistRow('My Artist');
      final song = await insertSongWithAlbum('a.mp3', null);

      await TableArtistSong.setSongsInArtist(artistId, [song]);

      final rows = await songRowsFor(artistId);

      expect(rows.single[TableArtistSong.songAlbumCol], song.songAlbum());
      expect(rows.single[TableArtistSong.songAlbumCol], isNot(isEmpty));
    });

    test('replaces the previous song list rather than appending', () async {
      final artistId = await insertArtistRow('My Artist');
      final songA = await insertSongWithAlbum('a.mp3', 'Album A');
      final songB = await insertSongWithAlbum('b.mp3', 'Album B');

      await TableArtistSong.setSongsInArtist(artistId, [songA, songB]);
      await TableArtistSong.setSongsInArtist(artistId, [songB]);

      final rows = await songRowsFor(artistId);

      expect(rows.map((e) => e[TableArtistSong.songIdCol]), [songB.id]);
    });
  });

  group('TableArtistSong.setSongsInArtistTx', () {
    test('can be used as part of a caller-provided transaction', () async {
      final artistId = await insertArtistRow('My Artist');
      final song = await insertSongWithAlbum('a.mp3', 'Album A');

      final db = await DatabaseController.database;
      await db.transaction((txn) => TableArtistSong.setSongsInArtistTx(txn, artistId, [song]));

      final rows = await songRowsFor(artistId);

      expect(rows.single[TableArtistSong.songIdCol], song.id);
    });
  });
}
