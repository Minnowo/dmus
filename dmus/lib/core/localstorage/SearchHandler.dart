

import 'package:dmus/core/data/provider/PlaylistProvider.dart';
import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';

import '../data/DataEntity.dart';


/// Handles searching for songs, playlists and albums
final class SearchHandler {

  SearchHandler._();


  /// Search for albums which match the given text
  static Future<List<Album>> searchForAlbums(List<String> search) async {

    if(search.isEmpty) {
      return [];
    }

    List<Album> result = await TableAlbum.albumsWhichMatch(search);

    return result;
  }


  /// Search for playlists which match the given text
  static Future<List<Playlist>> searchForPlaylists(List<String> search) async {

    if(search.isEmpty) {
      return [];
    }

    List<Playlist> result = await TablePlaylist.playlistsWhichMatch(search);

    return result;
  }


  /// Search for songs which match the given text
  static Future<List<Song>> searchForSongs(List<String> search) async {

    if(search.isEmpty) {
      return [];
    }

    List<Song> result = await TableSong.songsWhichMatch(search);

    return result;
  }


  /// Search for songs, albums and playlists which match the given text
  ///
  /// This is a more advanced search than some of the individual functions above, as it also searching for playlists which contain matching songs
  static Future<List<DataEntity>> searchForText(String search) async {

    List<String> terms = search.split("\s+").where((x) => x.isNotEmpty).toList();

    List<Song> s = await searchForSongs(terms);
    List<Playlist> p1 = await searchForPlaylists(terms);
    List<Playlist> p2 = await TablePlaylist.playlistsWithSongs(s);
    List<Album> a1 = await searchForAlbums(terms);
    List<Album> a2 = await TableAlbum.albumsWithSongs(s);

    if(p1.isNotEmpty && p2.isNotEmpty) {
      p1.removeWhere((e) => p2.any((e2) => e2.id == e.id));
    }

    if(a1.isNotEmpty && a2.isNotEmpty) {
      a1.removeWhere((e) => a2.any((e2) => e2.id == e.id));
    }

    return [
      ...s,
      ...p1,
      ...p2,
      ...a1,
      ...a2,
    ];
  }

}