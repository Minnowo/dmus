import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
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

  group('TablePlaylist.generateLikesPlaylist / generateLikesPlaylistTx', () {
    test('creates the Favorites playlist row', () async {
      await TablePlaylist.generateLikesPlaylist();

      final db = await DatabaseController.database;
      final rows =
          await db.query(TablePlaylist.name, where: '${TablePlaylist.idCol} = ?', whereArgs: [TablePlaylist.likedPlaylistId]);

      expect(rows, hasLength(1));
      expect(rows.single[TablePlaylist.titleCol], TablePlaylist.likedPlaylistName);
    });

    test('calling it again does not duplicate or change the row', () async {
      await TablePlaylist.generateLikesPlaylist();
      await TablePlaylist.generateLikesPlaylist();

      final db = await DatabaseController.database;
      final rows =
          await db.query(TablePlaylist.name, where: '${TablePlaylist.idCol} = ?', whereArgs: [TablePlaylist.likedPlaylistId]);

      expect(rows, hasLength(1));
    });
  });

  group('TablePlaylist.insertPlaylist', () {
    test('returns null and inserts nothing for an empty title', () async {
      final id = await TablePlaylist.insertPlaylist('', []);

      expect(id, isNull);

      final db = await DatabaseController.database;
      expect(await db.query(TablePlaylist.name), isEmpty);
    });

    test('creates the playlist row and its song list atomically', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);

      final playlistId = await TablePlaylist.insertPlaylist('My Playlist', await songsFor(songIds));

      expect(playlistId, isNotNull);

      final songs = await TablePlaylist.selectPlaylistSongs(playlistId!);

      expect(songs.map((e) => e.id), songIds);
    });

    test('can create a playlist with no songs', () async {
      final playlistId = await TablePlaylist.insertPlaylist('Empty Playlist', []);

      expect(playlistId, isNotNull);
      expect(await TablePlaylist.selectPlaylistSongs(playlistId!), isEmpty);
    });
  });

  group('TablePlaylist.updatePlaylist', () {
    test('returns null and changes nothing for an empty title', () async {
      final songIds = await insertSongs(['a.mp3']);
      final playlistId = await TablePlaylist.insertPlaylist('Original', await songsFor(songIds));

      final result = await TablePlaylist.updatePlaylist(playlistId!, '', []);

      expect(result, isNull);

      final db = await DatabaseController.database;
      final rows = await db.query(TablePlaylist.name, where: '${TablePlaylist.idCol} = ?', whereArgs: [playlistId]);
      expect(rows.single[TablePlaylist.titleCol], 'Original');
    });

    test('returns null for a playlist that does not exist', () async {
      final result = await TablePlaylist.updatePlaylist(999999, 'New Title', []);

      expect(result, isNull);
    });

    test('updates the title and replaces the song list', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3']);
      final playlistId = await TablePlaylist.insertPlaylist('Original', [(await songsFor(songIds))[0]]);

      await TablePlaylist.updatePlaylist(playlistId!, 'Renamed', await songsFor(songIds));

      final db = await DatabaseController.database;
      final rows = await db.query(TablePlaylist.name, where: '${TablePlaylist.idCol} = ?', whereArgs: [playlistId]);
      expect(rows.single[TablePlaylist.titleCol], 'Renamed');

      final songs = await TablePlaylist.selectPlaylistSongs(playlistId);
      expect(songs.map((e) => e.id), songIds);
    });
  });

  group('TablePlaylist.selectPlaylistSongs', () {
    test('returns an empty iterable for a playlist that does not exist', () async {
      expect(await TablePlaylist.selectPlaylistSongs(999999), isEmpty);
    });

    test('returns songs ordered by their playlist index', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3', 'c.mp3']);
      final playlistId = await TablePlaylist.insertPlaylist('My Playlist', await songsFor(songIds));

      final songs = await TablePlaylist.selectPlaylistSongs(playlistId!);

      expect(songs.map((e) => e.id).toList(), songIds);
    });
  });

  group('TablePlaylist.selectAll', () {
    test('returns an empty list when there are no playlists', () async {
      expect(await TablePlaylist.selectAll(), isEmpty);
    });

    test('returns every playlist with its songs', () async {
      final songIds = await insertSongs(['a.mp3']);
      await TablePlaylist.insertPlaylist('Playlist A', await songsFor(songIds));
      await TablePlaylist.insertPlaylist('Playlist B', []);

      final playlists = await TablePlaylist.selectAll();

      expect(playlists, hasLength(2));
      expect(playlists.map((e) => e.title), containsAll(['Playlist A', 'Playlist B']));
    });

    test('returns the same cached instance on a second call rather than re-querying', () async {
      final playlistId = await TablePlaylist.insertPlaylist('Original', []);

      final first = (await TablePlaylist.selectAll()).single;

      final db = await DatabaseController.database;
      await db.update(TablePlaylist.name, {TablePlaylist.titleCol: 'Changed Behind The Cache'},
          where: '${TablePlaylist.idCol} = ?', whereArgs: [playlistId]);

      final second = (await TablePlaylist.selectAll()).single;

      expect(second, same(first));
      expect(second.title, 'Original');
    });
  });

  group('TablePlaylist.deletePlaylist', () {
    test('deletes the playlist and its song list', () async {
      final songIds = await insertSongs(['a.mp3']);
      final playlistId = await TablePlaylist.insertPlaylist('My Playlist', await songsFor(songIds));

      final deleted = await TablePlaylist.deletePlaylist(playlistId!);

      expect(deleted, isTrue);

      final db = await DatabaseController.database;
      expect(await db.query(TablePlaylist.name), isEmpty);
      expect(await db.query(TablePlaylistSong.name), isEmpty);
    });

    test('returns false for a playlist that does not exist', () async {
      expect(await TablePlaylist.deletePlaylist(999999), isFalse);
    });
  });

  group('TablePlaylist.playlistsWithSongs', () {
    test('returns the playlists containing any of the given songs, without duplicates', () async {
      final songIds = await insertSongs(['a.mp3', 'b.mp3', 'c.mp3']);
      final songs = await songsFor(songIds);

      await TablePlaylist.insertPlaylist('Has A and B', [songs[0], songs[1]]);
      await TablePlaylist.insertPlaylist('Has Nothing Relevant', []);

      final result = await TablePlaylist.playlistsWithSongs([songs[0], songs[1]]);

      expect(result, hasLength(1));
      expect(result.single.title, 'Has A and B');
    });

    test('returns an empty list when no playlist contains the given songs', () async {
      final songIds = await insertSongs(['a.mp3']);

      expect(await TablePlaylist.playlistsWithSongs(await songsFor(songIds)), isEmpty);
    });
  });

  group('TablePlaylist.playlistsWhichMatch', () {
    test('returns an empty list for an empty search', () async {
      await TablePlaylist.insertPlaylist('My Playlist', []);

      expect(await TablePlaylist.playlistsWhichMatch([]), isEmpty);
    });

    test('matches playlists by title, case-insensitively', () async {
      await TablePlaylist.insertPlaylist('Road Trip', []);
      await TablePlaylist.insertPlaylist('Workout', []);

      final result = await TablePlaylist.playlistsWhichMatch(['road']);

      expect(result, hasLength(1));
      expect(result.single.title, 'Road Trip');
    });

    test('returns an empty list when nothing matches', () async {
      await TablePlaylist.insertPlaylist('Road Trip', []);

      expect(await TablePlaylist.playlistsWhichMatch(['nonexistent']), isEmpty);
    });
  });
}
