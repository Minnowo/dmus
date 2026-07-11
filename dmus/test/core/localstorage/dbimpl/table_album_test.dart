import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MyDataEntityCache.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbumSong.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
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

  Future<int> insertSongWithAlbum(String fileName, String? album) async {
    final songId = (await TableSong.insertSong(await createFakeSongFile(tempDir, fileName)))!;
    final db = await DatabaseController.database;
    await db.update(TableFMetadata.name, {TableFMetadata.albumCol: album},
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

  group('TableAlbum.generateAlbums', () {
    test('creates no albums when there are no songs', () async {
      await TableAlbum.generateAlbums();

      expect(await TableAlbum.selectAll(), isEmpty);
    });

    test('groups songs sharing the same album into one album row', () async {
      await insertSongWithAlbum('a.mp3', 'Greatest Hits');
      await insertSongWithAlbum('b.mp3', 'Greatest Hits');

      await TableAlbum.generateAlbums();

      final albums = await TableAlbum.selectAll();

      expect(albums, hasLength(1));
      expect(albums.single.title, 'Greatest Hits');
      expect(albums.single.songs, hasLength(2));
    });

    test('excludes songs with no album', () async {
      await insertSongWithAlbum('a.mp3', null);

      await TableAlbum.generateAlbums();

      expect(await TableAlbum.selectAll(), isEmpty);
    });

    test('rebuilding replaces the previous album set entirely', () async {
      await insertSongWithAlbum('a.mp3', 'Old Album');
      await TableAlbum.generateAlbums();
      expect((await TableAlbum.selectAll()).map((e) => e.title), ['Old Album']);

      await insertSongWithAlbum('b.mp3', 'New Album');
      await TableAlbum.generateAlbums();

      final albums = await TableAlbum.selectAll();
      expect(albums.map((e) => e.title), containsAll(['Old Album', 'New Album']));
    });
  });

  group('TableAlbum.insertAlbum', () {
    test('returns null and inserts nothing for an empty title', () async {
      final id = await TableAlbum.insertAlbum('', []);

      expect(id, isNull);

      final db = await DatabaseController.database;
      expect(await db.query(TableAlbum.name), isEmpty);
    });

    test('creates the album row and its song list atomically', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      final albumId = await TableAlbum.insertAlbum('My Album', await songsFor(songIds));

      expect(albumId, isNotNull);

      final songs = await TableAlbum.selectAlbumSongs(albumId!);

      expect(songs.map((e) => e.id), songIds);
    });
  });

  group('TableAlbum.selectAlbumSongs', () {
    test('returns an empty iterable for an album that does not exist', () async {
      expect(await TableAlbum.selectAlbumSongs(999999), isEmpty);
    });

    test('returns the songs belonging to the album', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      final albumId = await TableAlbum.insertAlbum('My Album', await songsFor(songIds));

      final songs = await TableAlbum.selectAlbumSongs(albumId!);

      expect(songs.map((e) => e.id).toSet(), songIds.toSet());
    });

    test('reflects the liked status of songs in the album', () async {
      final songIds = await insertSongs(['a.mp3']);
      final albumId = await TableAlbum.insertAlbum('My Album', await songsFor(songIds));
      await TableLikes.markSongLiked((await TableSong.selectFromId(songIds.single))!);
      MyDataEntityCache.clearForTesting();

      final songs = await TableAlbum.selectAlbumSongs(albumId!);

      expect(songs.single.liked, isTrue);
    });
  });

  group('TableAlbum.selectAll', () {
    test('returns an empty list when there are no albums', () async {
      expect(await TableAlbum.selectAll(), isEmpty);
    });

    test('returns every album with its songs', () async {
      final songIds = await insertSongs(['a.mp3']);
      await TableAlbum.insertAlbum('Album A', await songsFor(songIds));
      await TableAlbum.insertAlbum('Album B', []);

      final albums = await TableAlbum.selectAll();

      expect(albums, hasLength(2));
      expect(albums.map((e) => e.title), containsAll(['Album A', 'Album B']));
    });
  });

  group('TableAlbum.albumsWhichMatch', () {
    test('returns an empty list for an empty search', () async {
      await TableAlbum.insertAlbum('My Album', []);

      expect(await TableAlbum.albumsWhichMatch([]), isEmpty);
    });

    test('matches albums by title, case-insensitively', () async {
      await TableAlbum.insertAlbum('Greatest Hits', []);
      await TableAlbum.insertAlbum('Live Sessions', []);

      final result = await TableAlbum.albumsWhichMatch(['greatest']);

      expect(result, hasLength(1));
      expect(result.single.title, 'Greatest Hits');
    });

    test('returns an empty list when nothing matches', () async {
      await TableAlbum.insertAlbum('Greatest Hits', []);

      expect(await TableAlbum.albumsWhichMatch(['nonexistent']), isEmpty);
    });

    test('returns the same cached instance on a second call rather than re-querying', () async {
      final albumId = await TableAlbum.insertAlbum('Original', []);

      final first = (await TableAlbum.albumsWhichMatch(['original'])).single;

      final db = await DatabaseController.database;
      // Still has to match the 'original' search term at the SQL level, or
      // the row wouldn't be found at all on the second call.
      await db.update(TableAlbum.name, {TableAlbum.titleCol: 'original (changed behind the cache)'},
          where: '${TableAlbum.idCol} = ?', whereArgs: [albumId]);

      final second = (await TableAlbum.albumsWhichMatch(['original'])).single;

      expect(second, same(first));
      expect(second.title, 'Original');
    });
  });

  group('TableAlbum.albumsWithSongs', () {
    test('returns the albums containing any of the given songs, without duplicates', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3', 'c.mp3']);
      final songs = await songsFor(songIds);

      await TableAlbum.insertAlbum('Has A and B', [songs[0], songs[1]]);
      await TableAlbum.insertAlbum('Has Nothing Relevant', []);

      final result = await TableAlbum.albumsWithSongs([songs[0], songs[1]]);

      expect(result, hasLength(1));
      expect(result.single.title, 'Has A and B');
    });

    test('returns an empty list when no album contains the given songs', () async {
      final songIds = await insertSongs(['a.mp3']);

      expect(await TableAlbum.albumsWithSongs(await songsFor(songIds)), isEmpty);
    });
  });
}
