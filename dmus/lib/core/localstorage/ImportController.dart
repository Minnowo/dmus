


import 'dart:async';
import 'dart:io';

import '../Util.dart';
import '../data/DataEntity.dart';
import 'dbimpl/TablePlaylist.dart';
import 'dbimpl/TableSong.dart';

class ImportController {


  static final _songImportStartController = StreamController<File>.broadcast();

  static final _songImportedController = StreamController<Song>.broadcast();

  static final _playlistCreationStartController = StreamController<String>.broadcast();

  static final _playlistCreatedController = StreamController<Playlist>.broadcast();

  static final ImportController _instance = ImportController._();

  ImportController._();

  static ImportController get instance {
    return _instance;
  }

  factory ImportController() {
    return _instance;
  }

  static Stream<File> get onSongImportStart {
    return _songImportStartController.stream;
  }

  static Stream<Song> get onSongImported {
    return _songImportedController.stream;
  }

  static Stream<String> get onPlaylistCreationStart {
    return _playlistCreationStartController.stream;
  }

  static Stream<Playlist> get onPlaylistCreated {
    return _playlistCreatedController.stream;
  }


  static Future<void> importSong(File path) async {

    // don't need to check if it exsits because the insertSong function does

    _songImportStartController.add(path);

    logging.info("Importing $path...");

    int? songId = await TableSong.insertSong(path);

    if(songId == null) {
      logging.warning("Cannot import $path because it does not exist");
      return;
    }

    Song? s = await TableSong.selectFromId(songId);

    if(s == null) {
      logging.warning("Could not get song with id $songId, even though it was just imported???!?!");
      return;
    }

    _songImportedController.add(s);
  }


  static Future<void> createPlaylist(String title, List<Song> songs) async {

    _playlistCreationStartController.add(title);

    logging.info("Creating playlist $title");

    int? playlistId = await TablePlaylist.createPlaylist(title, songs);

    if(playlistId == null) {
      logging.info("Could not create playlist");
      return;
    }

    Playlist p = Playlist.withSongs(id: playlistId, title: title, songs: songs);

    _playlistCreatedController.add(p);
  }
}
