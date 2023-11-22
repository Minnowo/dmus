

import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';

import '../data/DataEntity.dart';

final class SearchHandler {

  SearchHandler._();

  static List<Song> _songCache = [];

  static Future<List<Album>> searchForAlbums(String text) async {

    return [];
  }
  static Future<List<Playlist>> searchForPlaylists(String text) async {

    List<String> search = text.split("\s+");

    List<Playlist> result = await TablePlaylist.playlistsWhichMatch(search);

    return result;
  }
  static Future<List<Song>> searchForSongs(String text) async {

    List<String> search = text.split("\s+");

    List<Song> result = await TableSong.songsWhichMatch(search);

    return result;
  }

  static Future<List<DataEntity>> searchForText(String search) async {

    List<Song> s = await searchForSongs(search);
    List<Playlist> p1 = await searchForPlaylists(search);
    List<Playlist> p2 = await TablePlaylist.playlistsWithSongs(s);

    if(p1.isNotEmpty && p2.isNotEmpty) {
      p1.removeWhere((e) => p2.any((e2) => e2.id == e.id));
    }

    return [
      ...s,
      ...p1,
      ...p2,
    ];
  }

}