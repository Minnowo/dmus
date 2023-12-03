


import 'package:dmus/core/localstorage/SearchHandler.dart';
import 'package:dmus/ui/widgets/BlueDivider.dart';
import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/data/UIEnumSettings.dart';
import '../Util.dart';
import '../dialogs/context/SongContextDialog.dart';
import '../lookfeel/CommonTheme.dart';
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
          Expanded(
            child: ListView(
              children: [
                ...buildSongDisplay(context),
                ...buildPlaylistDisplay(context),
                ...buildAlbumsDisplay(context),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              decoration: InputDecoration(
                hintText: 'Search...',
                suffixIcon: IconButton(
                  onPressed: _clearSearchbar,
                  icon: const Icon(Icons.clear),
                ),
              ),
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
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const ListTile(
          title: Row(
            children: [
              Text(
                "Songs",
                style: TEXT_BIG,
              ),
            ],
          ),
          dense: true,
        ),
      ),

      const BlueDivider(),

      for(final i in _songResults)
        SongListWidget(
          song: i,
          selected: false,
          leadWith: SongListWidgetLead.leadWithArtwork,
          trailWith: SongListWidgetTrail.trailWithDuration,
          onTap: () => JustAudioController.instance.playSong(i),
          onLongPress: () => SongContextDialog.showAsDialog(context, i),
          confirmDismiss: (d) => addToQueueSongDismiss(d, i),
          background: iconDismissibleBackgroundContainer(Theme.of(context).colorScheme.background, Icons.queue),
        ),
    ];
  }

  List<Widget> buildPlaylistDisplay(BuildContext context) {

    if(_playlistResults.isEmpty) {
      return [];
    }

    return [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const ListTile(
          title: Row(
            children: [
              Text(
                "Playlists",
                style: TEXT_BIG,
              ),
            ],
          ),
          dense: true,
        ),
      ),

      const BlueDivider(),

      for(final i in _playlistResults)
        PlaylistListWidget(playlist: i),
    ];
  }

  List<Widget> buildAlbumsDisplay(BuildContext context) {

    if(_albumResults.isEmpty) {
      return [];
    }

    return [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: const ListTile(
          title: Row(
            children: [
              Text(
                "Albums",
                style: TEXT_BIG,
              ),
            ],
          ),
          dense: true,
        ),
      ),

      const BlueDivider(),

      for(final i in _albumResults)
        PlaylistListWidget(playlist: i),
    ];
  }

  void _clearSearchbar(){

    _searchController.clear();
    _performSearch("");
  }

  void _performSearch(String query) {

    if(query.isEmpty) {
      _songResults.clear();
      _playlistResults.clear();
      _albumResults.clear();
      setState(() { });
      return;
    }

    SearchHandler.searchForText(query).then((value){

      _songResults.clear();
      _playlistResults.clear();
      _albumResults.clear();

      for(final i in value){
        logging.info(i);
        switch(i.entityType) {

          case EntityType.song:
            _songResults.add(i as Song);
          case EntityType.playlist:
            _playlistResults.add(i as Playlist);
          case EntityType.album:
            _albumResults.add(i as Album);
        }
      }

      setState(() { });
    });
  }
}
