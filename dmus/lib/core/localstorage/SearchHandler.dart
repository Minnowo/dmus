

import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';

import '../data/DataEntity.dart';

final class SearchHandler {

  SearchHandler._();

  static List<Song> _songCache = [];

  static Future<List<Album>> searchForAlbums(String text) async {

    return [];
  }
  static Future<List<Playlist>> searchForPlaylists(String text) async {

    return [];
  }
  static Future<List<Song>> searchForSongs(String text) async {

    List<String> search = text.split("\s+");

    List<Song> result = await TableSong.songsWhichMatch(search);

    return result;
  }

  static Future<List<DataEntity>> searchForText(String search) async {

    List<Song> s = await searchForSongs(search);

    return [
      ...s
    ];
  }

}