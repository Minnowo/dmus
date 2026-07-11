import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import '../../../test_helpers.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await setUpDbTest();
  });

  setUp(() async {
    await resetTestDatabase();
  });

  /// Inserts a bare tbl_song row (no metadata) and returns its id, to
  /// satisfy tbl_fmetadata's foreign key when testing TableFMetadata in
  /// isolation from TableSong.
  Future<int> insertBareSong(Database db, String songPath) {
    return db.insert(TableSong.name, {TableSong.songPathCol: songPath});
  }

  group('TableFMetadata.insertSongMetadataUnchecked', () {
    test('inserts a metadata row using the filename as a fallback title', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, '${tempDir.path}/song.mp3');
      final file = await createFakeSongFile(tempDir, 'song.mp3');

      final result = await TableFMetadata.insertSongMetadataUnchecked(db, songId, file);

      expect(result, isTrue);

      final rows = await db.query(TableFMetadata.name, where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);

      expect(rows, hasLength(1));
      expect(rows.single[TableFMetadata.titleCol], 'song.mp3');
    });

    test('returns false instead of throwing when a metadata row already exists for the song', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, '${tempDir.path}/song.mp3');
      final file = await createFakeSongFile(tempDir, 'song.mp3');

      await TableFMetadata.insertSongMetadataUnchecked(db, songId, file);
      final second = await TableFMetadata.insertSongMetadataUnchecked(db, songId, file);

      expect(second, isFalse);

      final rows = await db.query(TableFMetadata.name, where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);

      expect(rows, hasLength(1));
    });
  });

  group('TableFMetadata.updateSongMetadataUnchecked', () {
    test('overwrites the existing metadata row for the song', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, '${tempDir.path}/old.mp3');
      final oldFile = await createFakeSongFile(tempDir, 'old.mp3');
      await TableFMetadata.insertSongMetadataUnchecked(db, songId, oldFile);

      final newFile = await createFakeSongFile(tempDir, 'new.mp3');
      final result = await TableFMetadata.updateSongMetadataUnchecked(db, songId, newFile);

      expect(result, isTrue);

      final rows = await db.query(TableFMetadata.name, where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);

      expect(rows, hasLength(1));
      expect(rows.single[TableFMetadata.titleCol], 'new.mp3');
    });
  });

  group('TableFMetadata.selectExtraForSongId', () {
    test('returns null when there is no metadata row for the song', () async {
      final db = await DatabaseController.database;

      final extra = await TableFMetadata.selectExtraForSongId(db, 999);

      expect(extra, isNull);
    });

    test('returns null bpm/composer/isrc and an empty track artist for a file with no tags', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, '${tempDir.path}/song.mp3');
      final file = await createFakeSongFile(tempDir, 'song.mp3');
      await TableFMetadata.insertSongMetadataUnchecked(db, songId, file);

      final extra = await TableFMetadata.selectExtraForSongId(db, songId);

      expect(extra, isNotNull);
      expect(extra!.bpm, isNull);
      expect(extra.composer, isNull);
      expect(extra.isrc, isNull);
      expect(extra.trackArtist, '');
    });
  });

  group('TableFMetadata.fromMap', () {
    test('maps every column to the corresponding AudioMetadata field', () {
      final metadata = TableFMetadata.fromMap({
        TableFMetadata.titleCol: 'Title',
        TableFMetadata.albumCol: 'Album',
        TableFMetadata.albumArtistCol: 'Artist',
        TableFMetadata.bitrateCol: 320,
        TableFMetadata.trackNumberCol: 4,
        TableFMetadata.discNumberCol: 1,
        TableFMetadata.yearCol: 2020,
        TableFMetadata.durationMsCol: 5000,
        TableFMetadata.genreCol: 'Rock${TableFMetadata.GENRE_JOIN}Pop',
      });

      expect(metadata.title, 'Title');
      expect(metadata.album, 'Album');
      expect(metadata.artist, 'Artist');
      expect(metadata.bitrate, 320);
      expect(metadata.trackNumber, 4);
      expect(metadata.discNumber, 1);
      expect(metadata.year?.year, 2020);
      expect(metadata.duration, const Duration(milliseconds: 5000));
      expect(metadata.genres, ['Rock', 'Pop']);
    });

    test('leaves genres empty when the genre column is absent from the map', () {
      final metadata = TableFMetadata.fromMap({
        TableFMetadata.titleCol: 'Title',
        TableFMetadata.albumCol: null,
        TableFMetadata.albumArtistCol: null,
        TableFMetadata.bitrateCol: null,
        TableFMetadata.trackNumberCol: null,
        TableFMetadata.discNumberCol: null,
        TableFMetadata.yearCol: null,
        TableFMetadata.durationMsCol: null,
      });

      expect(metadata.genres, isEmpty);
    });
  });
}
