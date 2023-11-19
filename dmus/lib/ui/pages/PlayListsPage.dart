
import 'dart:async';

import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/ui/pages/SelectedPlaylistPage.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../dialogs/Util.dart';
import '../dialogs/context/PlaylistContextDialog.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends StatefulNavigationPage {

  const PlaylistsPage({super.key}) : super(icon: Icons.list, title: "Playlists");

  @override
  State<StatefulWidget> createState () => _PlaylistsPageState();
}


class _PlaylistsPageState extends State<PlaylistsPage>
{
  static const String onEmptyText = "Nothing is here!\nHit the + in the top right to create a playlist.";

  late final List<StreamSubscription> _subscriptions;

  List<Playlist> playlists = [];



  void _onPlaylistCreated(Playlist p) {

    setState(() {
      playlists.add(p);
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
  }


  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onPlaylistCreated.listen(_onPlaylistCreated),
      ImportController.onPlaylistUpdated.listen(_onPlaylistUpdated),
    ];

    TablePlaylist.selectAll().then((value) {

      setState(() {
        playlists.clear();
        playlists.addAll(value);
      });

    });
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
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
                  Text(
                    "No playlists",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Click to create",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => createPlaylist(context),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.purple,
                      ),
                      child: Icon(
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
              child: ListView.builder(
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  final playlist = playlists[index];
                  return InkWell(
                    onTap: () {
                      _openPlaylistPage(context, playlist);
                    },
                    child: ListTile(
                      title: Text(playlist.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                  PlaylistContextDialog(
                                      playlistContext: playlist,
                                      onDelete: () {
                                          setState(() {
                                          playlists.remove(playlist);
                                          });
                                        }),
                                );
                              },
                            child: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    ),
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            PlaylistContextDialog(
                                playlistContext: playlist,
                                onDelete: () {
                                  setState(() {
                                    playlists.remove(playlist);
                                  });
                                }),

                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      drawer: const SettingsDrawer(),
    );
  }

  void _openPlaylistPage(BuildContext context, Playlist playlist) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedPlaylistPage(playlistContext: playlist),
      ),
    );
  }
}
