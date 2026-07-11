import 'dart:io';

import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
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

  group('TableSong.insertSong', () {
    test('inserts both a song row and its metadata row atomically', () async {
      final file = await createFakeSongFile(tempDir, 'song.mp3');

      final songId = await TableSong.insertSong(file);

      expect(songId, isNotNull);

      final db = await DatabaseController.database;
      final songRows = await db.query(TableSong.name);
      final metadataRows = await db.query(TableFMetadata.name);

      expect(songRows, hasLength(1));
      expect(metadataRows, hasLength(1));
      expect(metadataRows.single[TableFMetadata.idCol], songId);
    });

    test('returns null and inserts nothing for a file that does not exist', () async {
      final songId = await TableSong.insertSong(File('${tempDir.path}/missing.mp3'));

      expect(songId, isNull);

      final db = await DatabaseController.database;

      expect(await db.query(TableSong.name), isEmpty);
      expect(await db.query(TableFMetadata.name), isEmpty);
    });

    test('re-importing the same path updates metadata in place rather than duplicating the song', () async {
      final file = await createFakeSongFile(tempDir, 'song.mp3');

      final firstId = await TableSong.insertSong(file);
      final secondId = await TableSong.insertSong(file);

      expect(secondId, firstId);

      final db = await DatabaseController.database;

      expect(await db.query(TableSong.name), hasLength(1));
      expect(await db.query(TableFMetadata.name), hasLength(1));
    });
  });

  group('TableSong.insertSongTx', () {
    test('can insert multiple songs as part of one caller-provided transaction', () async {
      final fileA = await createFakeSongFile(tempDir, 'a.mp3');
      final fileB = await createFakeSongFile(tempDir, 'b.mp3');

      final db = await DatabaseController.database;

      int? idA;
      int? idB;

      await db.transaction((txn) async {
        idA = await TableSong.insertSongTx(txn, fileA);
        idB = await TableSong.insertSongTx(txn, fileB);
      });

      expect(idA, isNotNull);
      expect(idB, isNotNull);
      expect(idA, isNot(idB));
      expect(await db.query(TableSong.name), hasLength(2));
    });
  });

  group('TableSong.selectSongIdUnchecked', () {
    test('returns the id for a known path', () async {
      final file = await createFakeSongFile(tempDir, 'song.mp3');
      final songId = await TableSong.insertSong(file);

      final db = await DatabaseController.database;
      final found = await TableSong.selectSongIdUnchecked(db, file);

      expect(found, songId);
    });

    test('returns null for an unknown path', () async {
      final db = await DatabaseController.database;
      final found = await TableSong.selectSongIdUnchecked(db, File('${tempDir.path}/unknown.mp3'));

      expect(found, isNull);
    });
  });

  group('TableSong.selectFromId', () {
    test('returns null for an id that does not exist', () async {
      expect(await TableSong.selectFromId(999999), isNull);
    });

    test('returns the song with its metadata joined in', () async {
      final file = await createFakeSongFile(tempDir, 'song.mp3');
      final songId = await TableSong.insertSong(file);

      final song = await TableSong.selectFromId(songId!);

      expect(song, isNotNull);
      expect(song!.id, songId);
      expect(song.title, 'song.mp3');
      expect(song.file.path, file.path);
    });

    test('returns the same cached instance on a second call rather than re-querying', () async {
      final file = await createFakeSongFile(tempDir, 'song.mp3');
      final songId = await TableSong.insertSong(file);

      final first = await TableSong.selectFromId(songId!);

      // Change the underlying row directly; if selectFromId re-queried, this
      // would be reflected in the result.
      final db = await DatabaseController.database;
      await db.update(TableFMetadata.name, {TableFMetadata.titleCol: 'Changed Behind The Cache'},
          where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);

      final second = await TableSong.selectFromId(songId);

      expect(second, same(first));
      expect(second!.title, 'song.mp3');
    });
  });

  group('TableSong.selectAllWithMetadata', () {
    test('returns an empty list when there are no songs', () async {
      expect(await TableSong.selectAllWithMetadata(), isEmpty);
    });

    test('returns every song with its metadata', () async {
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'a.mp3'));
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'b.mp3'));

      final songs = await TableSong.selectAllWithMetadata();

      expect(songs, hasLength(2));
      expect(songs.map((e) => e.title), containsAll(['a.mp3', 'b.mp3']));
    });

    test('flags a song as liked only when it is in the Favorites playlist', () async {
      // is_liked is driven by membership in the "Favorites" playlist
      // (tbl_playlist_song, playlist_id = TablePlaylist.likedPlaylistId) -
      // NOT by tbl_likes, despite the name of that table.
      final likedId = await TableSong.insertSong(await createFakeSongFile(tempDir, 'liked.mp3'));
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'not_liked.mp3'));

      final db = await DatabaseController.database;
      await db.rawInsert(
          'INSERT OR IGNORE INTO ${TablePlaylist.name} (${TablePlaylist.idCol}, ${TablePlaylist.titleCol}) VALUES (?, ?)',
          [TablePlaylist.likedPlaylistId, TablePlaylist.likedPlaylistName]);
      await db.insert(TablePlaylistSong.name, {
        TablePlaylistSong.playlistIdCol: TablePlaylist.likedPlaylistId,
        TablePlaylistSong.songIdCol: likedId,
        TablePlaylistSong.songIndexCol: 0,
      });

      final songs = await TableSong.selectAllWithMetadata();

      final liked = songs.firstWhere((e) => e.id == likedId);
      final notLiked = songs.firstWhere((e) => e.id != likedId);

      expect(liked.liked, isTrue);
      expect(notLiked.liked, isFalse);
    });
  });

  group('TableSong.deleteSongById', () {
    test('deletes the song and cascades to its metadata and likes rows', () async {
      final songId = await TableSong.insertSong(await createFakeSongFile(tempDir, 'song.mp3'));

      final db = await DatabaseController.database;
      await db.rawInsert('INSERT INTO ${TableLikes.name} (${TableLikes.songIdCol}) VALUES (?)', [songId]);

      final deleted = await TableSong.deleteSongById(songId!);

      expect(deleted, isTrue);
      expect(await db.query(TableSong.name), isEmpty);
      expect(await db.query(TableFMetadata.name), isEmpty);
      expect(await db.query(TableLikes.name), isEmpty);
    });

    test('returns false for an id that does not exist', () async {
      expect(await TableSong.deleteSongById(999999), isFalse);
    });
  });

  group('TableSong.songsWhichMatch', () {
    test('returns an empty list for an empty search', () async {
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'alpha.mp3'));

      expect(await TableSong.songsWhichMatch([]), isEmpty);
    });

    test('matches songs by title, case-insensitively', () async {
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'alpha.mp3'));
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'beta.mp3'));

      final results = await TableSong.songsWhichMatch(['ALPHA']);

      expect(results, hasLength(1));
      expect(results.single.title, 'alpha.mp3');
    });

    test('returns an empty list when nothing matches', () async {
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'alpha.mp3'));

      expect(await TableSong.songsWhichMatch(['nonexistent']), isEmpty);
    });

    test('matches songs by album even when the title does not match', () async {
      final songId = await TableSong.insertSong(await createFakeSongFile(tempDir, 'alpha.mp3'));

      final db = await DatabaseController.database;
      await db.update(TableFMetadata.name, {TableFMetadata.albumCol: 'Greatest Hits'},
          where: '${TableFMetadata.idCol} = ?', whereArgs: [songId]);

      final results = await TableSong.songsWhichMatch(['greatest']);

      expect(results, hasLength(1));
      expect(results.single.id, songId);
    });

    test('ORs multiple search terms together', () async {
      await TableSong.insertSong(await createFakeSongFile(tempDir, 'alpha.mp3'));

      final results = await TableSong.songsWhichMatch(['nonexistent', 'alpha']);

      expect(results, hasLength(1));
    });
  });

  group('TableSong.filterPathsWhichAreInDb', () {
    test('does nothing for an empty list', () async {
      final paths = <File>[];

      await TableSong.filterPathsWhichAreInDb(paths);

      expect(paths, isEmpty);
    });

    test('removes paths already present in the db, keeping unknown ones', () async {
      final knownFile = await createFakeSongFile(tempDir, 'known.mp3');
      await TableSong.insertSong(knownFile);

      final unknownFile = File('${tempDir.path}/unknown.mp3');
      final paths = [knownFile, unknownFile];

      await TableSong.filterPathsWhichAreInDb(paths);

      expect(paths, [unknownFile]);
    });
  });
}
