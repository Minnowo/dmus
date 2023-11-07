
import 'dart:async';

import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';
import '../../core/data/DataEntity.dart';
import '../dialogs/context/PlaylistContextDialog.dart';
import '../widgets/SettingsDrawer.dart';

class AlbumsPage extends StatefulNavigationPage {

  const AlbumsPage({super.key}) : super(icon: Icons.album, title: "Albums");

  @override
  State<StatefulWidget> createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage>{

  static const String onEmptyText = "Nothing is here!\nHit the + in the top right to create a playlist.";

  late final List<StreamSubscription> _subscriptions;

  List<Album> albums = [];

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      // ImportController.onSongImported.listen(_onSongImported),
    ];

    TableAlbum.selectAll().then((value) {

      setState(() {
        albums.clear();
        albums.addAll(value);
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
              icon: const Icon(Icons.refresh),
              onPressed: () {
                TableAlbum.selectAll().then((value) {

                  setState(() {
                    albums.clear();
                    albums.addAll(value);
                  });

                });
              },
            ),
          ],
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            if(albums.isEmpty)
              const Center(
                child: Text(onEmptyText, textAlign: TextAlign.center,)
              )

            else
              Expanded(
                  child:ListView.builder(
                      itemCount: albums.length,
                      itemBuilder: (context, index) {

                        final playlist = albums[index];

                        return InkWell(
                            child: ListTile(
                              title: Text(playlist.title),
                              trailing: Text(formatDuration(playlist.duration)),
                            ),
                            onTap: () async {
                              logging.finest(playlist);

                              AudioController.queuePlaylist(playlist);

                              await AudioController.playQueue();
                            },
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
}
