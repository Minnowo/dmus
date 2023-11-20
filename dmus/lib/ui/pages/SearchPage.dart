


import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
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

              for(final i in _songResults)
                SongListWidget(song: i),

              for(final i in _albumResults)
                PlaylistListWidget(playlist: i),

              // for(final i in _playlistResults)
              //   SongListWidget(song: i),

            ],
          ),
        ),
      ],
    ),
      endDrawerEnableOpenDragGesture: true,
      drawer: const SettingsDrawer(),
    );
  }

  void _performSearch(String query) {

  }
}
