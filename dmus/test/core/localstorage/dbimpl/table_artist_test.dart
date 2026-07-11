import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableArtist.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
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

  Future<int> insertSongWithAlbumArtist(String fileName, String? albumArtist) async {
    final songId = (await TableSong.insertSong(await createFakeSongFile(tempDir, fileName)))!;
    final db = await DatabaseController.database;
    await db.update(TableFMetadata.name, {TableFMetadata.albumArtistCol: albumArtist},
        where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);
    return songId;
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

  group('TableArtist.generateArtists', () {
    test('creates no artists when there are no songs', () async {
      await TableArtist.generateArtists();

      expect(await TableArtist.selectAll(), isEmpty);
    });

    test('groups songs sharing the same album artist into one artist row', () async {
      await insertSongWithAlbumArtist('a.mp3', 'The Band');
      await insertSongWithAlbumArtist('b.mp3', 'The Band');

      await TableArtist.generateArtists();

      final artists = await TableArtist.selectAll();

      expect(artists, hasLength(1));
      expect(artists.single.title, 'The Band');
      expect(artists.single.songs, hasLength(2));
    });

    test('excludes songs with no album artist', () async {
      await insertSongWithAlbumArtist('a.mp3', null);

      await TableArtist.generateArtists();

      expect(await TableArtist.selectAll(), isEmpty);
    });
  });

  group('TableArtist.insertArist', () {
    test('returns null and inserts nothing for an empty title', () async {
      final id = await TableArtist.insertArist('', []);

      expect(id, isNull);

      final db = await DatabaseController.database;
      expect(await db.query(TableArtist.name), isEmpty);
    });

    test('creates the artist row and its song list atomically', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      final artistId = await TableArtist.insertArist('My Artist', await songsFor(songIds));

      expect(artistId, isNotNull);

      final songs = await TableArtist.selectArtistSongs(artistId!);

      expect(songs.map((e) => e.id).toSet(), songIds.toSet());
    });
  });

  group('TableArtist.selectArtistSongs', () {
    test('returns an empty iterable for an artist that does not exist', () async {
      expect(await TableArtist.selectArtistSongs(999999), isEmpty);
    });

    test('returns the songs belonging to the artist', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      final artistId = await TableArtist.insertArist('My Artist', await songsFor(songIds));

      final songs = await TableArtist.selectArtistSongs(artistId!);

      expect(songs.map((e) => e.id).toSet(), songIds.toSet());
    });
  });

  group('TableArtist.selectAll', () {
    test('returns an empty list when there are no artists', () async {
      expect(await TableArtist.selectAll(), isEmpty);
    });

    test('returns every artist (as Album entities) with their songs', () async {
      final songIds = await insertSongs(['a.mp3']);
      await TableArtist.insertArist('Artist A', await songsFor(songIds));
      await TableArtist.insertArist('Artist B', []);

      final artists = await TableArtist.selectAll();

      expect(artists, hasLength(2));
      expect(artists.map((e) => e.title), containsAll(['Artist A', 'Artist B']));
      // TableArtist.selectAll models artists using the Album entity type -
      // there is no dedicated Artist DataEntity in this codebase.
      expect(artists.every((e) => e.entityType == EntityType.album), isTrue);
    });
  });
}
