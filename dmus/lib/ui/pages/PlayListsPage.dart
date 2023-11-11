
import 'dart:async';

import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/ui/pages/SelectedPlaylistPage.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../dialogs/Util.dart';
import '../dialogs/context/PlaylistContextDialog.dart';
import '../lookfeel/Animations.dart';
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

            if(playlists.isEmpty)
              const Center(
                child: Text(onEmptyText, textAlign: TextAlign.center,)
              )

            else
              Expanded(
                  child:ListView.builder(
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {

                        final playlist = playlists[index];

                        return InkWell(
                            child: ListTile(
                              title: Text(playlist.title),
                              trailing: Text(formatDuration(playlist.duration)),
                            ),
                            onTap: () => _openPlaylistPage(context, playlist),
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => PlaylistContextDialog(playlistContext: playlist,),
                              );
                            }
                        );
                      })
              )
          ],
        ) ,
        drawer: const SettingsDrawer()
    );
  }
  
  void _openPlaylistPage(BuildContext context, Playlist playlist) {

    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlist));

  }
}
