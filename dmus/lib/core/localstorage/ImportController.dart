
import 'dart:async';
import 'dart:io';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/data/MyDataEntityCache.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import '/generated/l10n.dart';

import '../Util.dart';
import '../data/DataEntity.dart';
import 'dbimpl/TablePlaylist.dart';
import 'dbimpl/TableSong.dart';
import 'dbimpl/TableWatchDirectory.dart';



/// The Import Controller
///
/// Handles importing data into the database
final class ImportController {

  ImportController._();

  static int _importCount = 0;
  static bool _supressSnackBars = false;
  static bool _silencePubs = false;


  /// A pub for when an import has completed for a song
  static final _songImportedController = StreamController<Song>.broadcast();

  /// A pub for when a song is deleted
  static final _songDeletedIdController = StreamController<int>.broadcast();

  /// A pub for when a song is deleted
  static final _songDeletedController = StreamController<Song>.broadcast();

  /// A pub for when a playlist has been created
  static final _playlistCreatedController = StreamController<Playlist>.broadcast();

  /// A pub for when a playlist has been created
  static final _playlistUpdatedController = StreamController<Playlist>.broadcast();

  /// A pub for when a playlist has been deleted
  static final _playlistDeletedController = StreamController<Playlist>.broadcast();

  /// A pub for when the albums have been rebuilt
  static final _albumsRebuiltController = StreamController<void>.broadcast();


  static bool get reduceSnackBars {
    return _supressSnackBars;
  }

  /// A pub for when a song was deleted with only the id known
  static Stream<int> get onSongDeletedId {
    return _songDeletedIdController.stream;
  }


  /// A pub for when an import has completed for a song
  static Stream<Song> get onSongDeleted {
    return _songDeletedController.stream;
  }


  /// A pub for when an import has completed for a song
  static Stream<Song> get onSongImported {
    return _songImportedController.stream;
  }


  /// A pub for when a playlist has been created
  static Stream<Playlist> get onPlaylistCreated {
    return _playlistCreatedController.stream;
  }


  /// A pub for when a playlist has been deleted
  static Stream<Playlist> get onPlaylistDeleted {
    return _playlistDeletedController.stream;
  }


  /// A pub for when a playlist has been updated
  static Stream<Playlist> get onPlaylistUpdated {
    return _playlistUpdatedController.stream;
  }


  /// A pub for when the albums have been rebuilt
  static Stream<void> get onAlbumCacheRebuild {
    return _albumsRebuiltController.stream;
  }


  /// Runs imports for watch folders if any exist
  static Future<void> checkWatchFolders() async {

    final watchDirs = await TableWatchDirectory.selectAll();

    if(watchDirs.isEmpty) return;

    final c = await getExternalStoragePermission();

    if(!c) {
      logging.warning("No external storage permission! Trying to check watch dirs anyway!");
    }

    MessagePublisher.publishSnackbar(SnackBarData(text: "${S.current.checkingDirectories1} ${watchDirs.length} ${S.current.checkingDirectories2}"));

    for(final d in watchDirs) {

      Directory dd = Directory(d.directoryPath);

      if(await dd.exists()) {
        _silencePubs = true;
        await importSongFromDirectory(dd, d.isRecursive, true);
        _silencePubs = false;
      }
    }
  }


  /// Import all files which are known in the db
  static Future<void> reimportAll() async {

    final db = await DatabaseController.database;

    final results = await db.query(TableSong.name);

    for(final i in results) {

      final  id = i[TableSong.idCol] as int;
      final path = i[TableSong.songPathCol] as String;

      final filePath = File(path);

      if(!await filePath.exists()) {
        MessagePublisher.publishSnackbar(SnackBarData(text: "${S.current.songPathDoesNotExist1} $path ${S.current.songPathDoesNotExist2}"));
        await TableSong.deleteSongById(id);
        _songDeletedIdController.add(id);
        continue;
      }

      await importSong(filePath);
    }

  }


  /// Rebuilds the albums
  static Future<void> rebuildAlbums() async {

    await TableAlbum.generateAlbums();

    _albumsRebuiltController.add(null);

  }


  /// Finish importing and build the album cache
  static Future<void> endImports() async {

    if(_importCount < 1) return;

    await rebuildAlbums();

    _importCount = 0;
  }


  /// Deletes the song from the database
  static Future<void> deleteSong(Song s) async {

    await TableSong.deleteSongById(s.id);

    MyDataEntityCache.deleteFromCache(s.id);

    _songDeletedController.add(s);

    await rebuildAlbums();
  }


  /// Adds the song path to the blacklist and deletes it from the database
  static Future<void> blockSong(Song s) async {
    await TableBlacklist.addToBlacklist(s.file.path);
    await deleteSong(s);
  }


  /// Imports a song from a file
  ///
  /// Process and adds the song to the database
  ///
  /// This sends out events accordingly
  static Future<void> importSong(File path) async {

    // don't need to check if it exists because the insertSong function does
    if(TableBlacklist.isBlacklisted(path.path)) {
      return;
    }

    logging.info("Importing $path...");

    int? songId = await TableSong.insertSong(path);

    if(songId == null) {
      logging.warning("Cannot import $path because it does not exist");
      if(!_silencePubs) {
        MessagePublisher.publishSomethingWentWrong(
            S.current.cannotImportSongDoesNotExist);
      }
      return;
    }

    Song? s = await TableSong.selectFromId(songId);

    if(s == null) {
      logging.warning("Could not get song with id $songId, even though it was just imported!");
      if(!_silencePubs) {
        MessagePublisher.publishSomethingWentWrong(
            S.current.dbError);
      }
      return;
    }

    _importCount += 1;

    _songImportedController.add(s);
  }


  /// Imports 0 or more songs from a list of files
  ///
  /// Process and adds the songs to the database
  ///
  /// This sends out events accordingly
  static Future<void> importSongs(List<File> files) async {

    if(files.length > 1) {
      if(!_silencePubs) {
        MessagePublisher.publishSnackbar(
            SnackBarData(text: "${S.current.importingSongs1} ${files.length} ${S.current.importingSongs2}"));
      }
      _supressSnackBars = true;
    }

    logging.info(files);

    for(var f in files) {
      await ImportController.importSong(f);
    }

    await endImports();

    if(files.length > 3) {
      _supressSnackBars = false;
    }
  }


  /// Imports any audio files in the given directory
  ///
  /// Process and adds the songs to the database
  ///
  /// This sends out events accordingly
  static Future<void> importSongFromDirectory(Directory dir, bool isRecursive, bool importOnlyIfNotInDb) async {

    bool a = await getExternalStoragePermission();

    if(!a) {
      logging.warning("Cannot import from folder $dir because there is no permission, trying anyway");
    }

    try {

      var files = await dir.list(recursive: isRecursive)
          .where((event) => musicFileExtensions.contains(fileExtensionNoDot(event.path).toLowerCase()))
          .where((event) => !TableBlacklist.isBlacklisted(event.path))
          .map((event) => File(event.path))
          .toList();

      if(importOnlyIfNotInDb) {
        await TableSong.filterPathsWhichAreInDb(files);
        if(files.isEmpty) {
          return;
        }
      }

      if(files.isEmpty) {
        if(!_silencePubs) {
          MessagePublisher.publishSnackbar(SnackBarData(text: S.current.noFilesInFolder));
        }
        return;
      }

      logging.finest("Found files $files");

      await importSongs(files);
    }
    on PathAccessException catch(e) {

      logging.warning("There is actually no permissions to read this path! $e");

      if(!_silencePubs) {
        MessagePublisher.publishSomethingWentWrong(
            S.current.noPermissionInDirectory);
      }
    }
    on Exception catch(e) {

      logging.warning("Error while reading files from directory! $e");

      if(!_silencePubs) {
        MessagePublisher.publishRawException(e);
      }
    }
  }


  /// Deletes a playlist
  ///
  /// This sends out events accordingly
  static Future<void> deletePlaylist(Playlist playlist) async {

    await TablePlaylist.deletePlaylist(playlist.id);

    _playlistDeletedController.add(playlist);
  }


  /// Creates a playlist
  ///
  /// Process and adds the playlist to the database
  ///
  /// This sends out events accordingly
  static Future<void> createPlaylist(String title, List<Song> songs) async {

    logging.info("Creating playlist $title");

    int? playlistId = await TablePlaylist.insertPlaylist(title, songs);

    if(playlistId == null) {
      logging.info("Could not create playlist");
      MessagePublisher.publishSomethingWentWrong(S.current.emptyName);
      return;
    }

    Playlist p = Playlist.withSongs(id: playlistId, title: title, songs: songs);
    await p.setPictureCacheKey(null);
    _playlistCreatedController.add(p);
  }


  /// Edits a playlist by id
  ///
  /// Sets the playlists title and songs to the given values
  ///
  /// This sends out events accordingly
  static Future<void> editPlaylist(int playlistId, String title, List<Song> songs) async {

    logging.info("Creating playlist $title");

    int? playlistId0 = await TablePlaylist.updatePlaylist(playlistId, title, songs);

    if(playlistId0 == null) {
      logging.info("Could not edit playlist");
      MessagePublisher.publishSomethingWentWrong(S.current.cannotEditPlaylist);
      return;
    }

    Playlist p = Playlist.withSongs(id: playlistId, title: title, songs: songs);
    await p.setPictureCacheKey(null);

    _playlistUpdatedController.add(p);
  }


  /// Updates the playlist in the database and returns the playlist
  static Future<Playlist> updatePlaylistInDb(Playlist pl) async {

    logging.info("Creating playlist ${pl.title}");

    int? playlistId0 = await TablePlaylist.updatePlaylist(pl.id, pl.title, pl.songs);

    if(playlistId0 == null) {
      logging.info("Could not edit playlist");
      MessagePublisher.publishSomethingWentWrong(S.current.cannotEditPlaylist);
      return pl;
    }

    await pl.updatePicture();
    _playlistUpdatedController.add(pl);

    return pl;
  }


  static Future<void> pubLikedPlaylistUpdated(Playlist p) async {

    _supressSnackBars = true;
    _playlistUpdatedController.add(p);
    _supressSnackBars = false;
  }
}
