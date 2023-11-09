
import 'dart:async';
import 'dart:io';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';

import '../Util.dart';
import '../data/DataEntity.dart';
import 'dbimpl/TablePlaylist.dart';
import 'dbimpl/TableSong.dart';



/// The Import Controller
///
/// Handles importing data into the database
final class ImportController {

  ImportController._();

  static int _importCount = 0;


  /// A pub for when an import has completed for a song
  static final _songImportedController = StreamController<Song>.broadcast();

  /// A pub for when a playlist has been created
  static final _playlistCreatedController = StreamController<Playlist>.broadcast();

  /// A pub for when a playlist has been created
  static final _playlistUpdatedController = StreamController<Playlist>.broadcast();

  /// A pub for when the albums have been rebuilt
  static final _albumsRebuiltController = StreamController<void>.broadcast();



  /// A pub for when an import has completed for a song
  static Stream<Song> get onSongImported {
    return _songImportedController.stream;
  }


  /// A pub for when a playlist has been created
  static Stream<Playlist> get onPlaylistCreated {
    return _playlistCreatedController.stream;
  }


  /// A pub for when a playlist has been updated
  static Stream<Playlist> get onPlaylistUpdated {
    return _playlistUpdatedController.stream;
  }


  /// A pub for when the albums have been rebuilt
  static Stream<void> get onAlbumCacheRebuild {
    return _albumsRebuiltController.stream;
  }



  /// Finish importing and build the album cache
  static Future<void> endImports() async {

    if(_importCount < 1) return;

    await TableAlbum.generateAlbums();

    _albumsRebuiltController.add(null);

    _importCount = 0;
  }


  /// Imports a song from a file
  ///
  /// Process and adds the song to the database
  ///
  /// This sends out events accordingly
  static Future<void> importSong(File path) async {

    // don't need to check if it exists because the insertSong function does

    logging.info("Importing $path...");

    int? songId = await TableSong.insertSong(path);

    if(songId == null) {
      logging.warning("Cannot import $path because it does not exist");
      MessagePublisher.publishSomethingWentWrong("Cannot import song because the file does not exist!");
      return;
    }

    Song? s = await TableSong.selectFromId(songId);

    if(s == null) {
      logging.warning("Could not get song with id $songId, even though it was just imported???!?!");
      MessagePublisher.publishSomethingWentWrong("Cannot import song event though it was just imported!?!??!");
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

    for(var f in files) {
      await ImportController.importSong(f);
    }

    await endImports();
  }


  /// Imports any audio files in the given directory
  ///
  /// Process and adds the songs to the database
  ///
  /// This sends out events accordingly
  static Future<void> importSongFromDirectory(Directory dir, bool isRecursive) async {

    bool a = await getExternalStoragePermission();

    if(!a) {
      logging.warning("Cannot import from folder $dir because there is no permission, trying anyway");
    }

    try {

      var files = await dir.list(recursive: isRecursive)
          .where((event) => musicFileExtensions.contains(fileExtensionNoDot(event.path).toLowerCase()))
          .map((event) => File(event.path))
          .toList();

      logging.finest("Found files $files");

      if(files.isEmpty) {
        MessagePublisher.publishSomethingWentWrong("No files found in this folder!");
        return;
      }

      await importSongs(files);
    }
    on PathAccessException catch(e) {

      logging.warning("There is actually no permissions to read this path! $e");

      MessagePublisher.publishSomethingWentWrong("No permission to list files in this directory!");
    }
    on Exception catch(e) {

      logging.warning("Error while reading files from directory! $e");

      MessagePublisher.publishRawException(e);
    }
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
      MessagePublisher.publishSomethingWentWrong("Cannot create playlist with an empty name!");
      return;
    }

    Playlist p = Playlist.withSongs(id: playlistId, title: title, songs: songs);

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
      MessagePublisher.publishSomethingWentWrong("Cannot edit playlist with an empty name or which does not exist!");
      return;
    }

    Playlist p = Playlist.withSongs(id: playlistId, title: title, songs: songs);

    _playlistUpdatedController.add(p);
  }
}
