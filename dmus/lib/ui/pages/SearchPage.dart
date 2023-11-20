


import 'package:dmus/core/localstorage/SearchHandler.dart';
import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class SearchPage extends StatefulNavigationPage {
  const SearchPage({super.key}) : super(icon: Icons.search, title: "Search");

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final TextEditingController _searchController = TextEditingController();

  List<Song> _songResults = [];
  List<Album> _albumResults = [];
  List<Playlist> _playlistResults = [];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            onChanged: _performSearch,
            decoration: const InputDecoration(
              hintText: 'Search...',
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              ...buildSongDisplay(context),
              ...buildPlaylistDisplay(context),
              ...buildAlbumsDisplay(context),
            ],
          ),
        ),
      ],
    ),
      endDrawerEnableOpenDragGesture: true,
      drawer: const SettingsDrawer(),
    );
  }

  List<Widget> buildSongDisplay(BuildContext context) {

    if(_songResults.isEmpty) {
      return [];
    }

    return [

      const Text("--- Songs ---"),

      for(final i in _songResults)
        SongListWidget(song: i),
    ];
  }

  List<Widget> buildPlaylistDisplay(BuildContext context) {

    if(_playlistResults.isEmpty) {
      return [];
    }

    return [

      const Text("--- Playlists---"),

      for(final i in _playlistResults)
        PlaylistListWidget(playlist: i),
    ];
  }

  List<Widget> buildAlbumsDisplay(BuildContext context) {

    if(_albumResults.isEmpty) {
      return [];
    }

    return [

      const Text("--- Albums ---"),

      for(final i in _albumResults)
        PlaylistListWidget(playlist: i),
    ];
  }

  void _performSearch(String query) {

    logging.info("Searched for $query");

    SearchHandler.searchForSongs(query).then((value){

      _songResults.clear();
      _songResults.addAll(value);

      setState(() { });
    });
  }
}
