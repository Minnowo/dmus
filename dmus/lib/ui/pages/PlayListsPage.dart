
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/dbimpl/TableLikes.dart';
import '../dialogs/Util.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends StatefulNavigationPage {

  const PlaylistsPage({super.key}) : super(icon: Icons.list, title: "Playlists");

  @override
  State<StatefulWidget> createState () => _PlaylistsPageState();
}


class _PlaylistsPageState extends State<PlaylistsPage>
{

  late final List<StreamSubscription> _subscriptions;

  List<Playlist> playlists = [];

  void _onPlaylistCreated(Playlist p) {

    setState(() {
      playlists.add(p);
    });
  }

  void _onPlaylistDeleted(Playlist p) {

    setState(() {
      playlists.removeWhere((element) => element.id == p.id);
    });
  }

  void _onPlaylistUpdated(Playlist p) {

    for(int i = 0; i < playlists.length; i++){

      if(playlists[i].id == p.id) {

        setState(() {
          playlists[i] = p;
        });

        return;
      }
    }

    _onPlaylistCreated(p);
  }


  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onPlaylistCreated.listen(_onPlaylistCreated),
      ImportController.onPlaylistUpdated.listen(_onPlaylistUpdated),
      ImportController.onPlaylistDeleted.listen(_onPlaylistDeleted),
    ];

    TableLikes.reGenerateLikedPlaylist()
        .then((e) => TablePlaylist.selectAll().then((value) {

      setState(() {
        playlists.clear();
        playlists.addAll(value);
      });

    }));
  }


  @override
  void dispose() {

    for(final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          PopupMenuButton<PlaylistSort>(
            onSelected: sortPlaylistsBy,
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              // Define the items in the menu
              return <PopupMenuEntry<PlaylistSort>>[
                const PopupMenuItem(
                  value: PlaylistSort.byId,
                  child: Text('Sort by ID'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byTitle,
                  child: Text('Sort by Title'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byDuration,
                  child: Text('Sort by Duration'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byNumberOfTracks,
                  child: Text('Sort by Number of Tracks'),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => createPlaylist(context),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (playlists.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No playlists",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Click to create",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () => createPlaylist(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView(
                children: [
                  for(final i in playlists) 
                    PlaylistListWidget(playlist: i)
                ],
              ),
            ),
        ],
      ),
      drawer: const SettingsDrawer(),
    );
  }



  void sortPlaylistsBy(PlaylistSort sort){

    switch(sort) {
      case PlaylistSort.byId:
        playlists.sort((a, b) => a.id.compareTo(b.id));
      case PlaylistSort.byTitle:
        playlists.sort((a, b) => compareNatural(a.title, b.title));
      case PlaylistSort.byNumberOfTracks:
        playlists.sort((a, b) => a.songs.length.compareTo(b.songs.length));
      case PlaylistSort.byDuration:
        playlists.sort((a, b) => a.duration.compareTo(b.duration));
    }

    setState(() { });
  }
}
