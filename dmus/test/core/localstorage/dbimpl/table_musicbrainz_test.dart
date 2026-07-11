import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/FullMetadataReader.dart';
import 'package:dmus/core/localstorage/dbimpl/TableMusicBrainz.dart';
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

  Future<int> insertBareSong(Database db, String fileName) {
    return db.insert(TableSong.name, {TableSong.songPathCol: '${tempDir.path}/$fileName'});
  }

  const ids = MusicBrainzIds(
    recordingId: 'recording-1',
    releaseId: 'release-1',
    releaseGroupId: 'release-group-1',
    releaseTrackId: 'release-track-1',
    artistId: 'artist-1',
    albumArtistId: 'album-artist-1',
    workId: 'work-1',
    acoustId: 'acoust-1',
  );

  group('TableMusicBrainz.setMusicBrainzIdsUnchecked', () {
    test('inserts a row with all of the given ids', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, ids);

      final result = await TableMusicBrainz.selectForSongId(db, songId);

      expect(result, isNotNull);
      expect(result!.recordingId, 'recording-1');
      expect(result.releaseId, 'release-1');
      expect(result.releaseGroupId, 'release-group-1');
      expect(result.releaseTrackId, 'release-track-1');
      expect(result.artistId, 'artist-1');
      expect(result.albumArtistId, 'album-artist-1');
      expect(result.workId, 'work-1');
      expect(result.acoustId, 'acoust-1');
    });

    test('replaces an existing row for the song rather than throwing', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, ids);
      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, const MusicBrainzIds(recordingId: 'recording-2'));

      final result = await TableMusicBrainz.selectForSongId(db, songId);

      expect(result!.recordingId, 'recording-2');
      expect(result.releaseId, isNull);
    });

    test('does not write a row when the ids are all empty', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, const MusicBrainzIds());

      expect(await TableMusicBrainz.selectForSongId(db, songId), isNull);
    });

    test('removes an existing row when set to all-empty ids', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');
      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, ids);

      await TableMusicBrainz.setMusicBrainzIdsUnchecked(db, songId, const MusicBrainzIds());

      expect(await TableMusicBrainz.selectForSongId(db, songId), isNull);
    });
  });

  group('TableMusicBrainz.selectForSongId', () {
    test('returns null for a song with no MusicBrainz ids on file', () async {
      final db = await DatabaseController.database;
      final songId = await insertBareSong(db, 'a.mp3');

      expect(await TableMusicBrainz.selectForSongId(db, songId), isNull);
    });
  });
}
