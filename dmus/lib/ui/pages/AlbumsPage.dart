
import 'dart:async';
import 'dart:io';

import 'package:dmus/core/localstorage/dbimpl/TableAlbum.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImageCacheController.dart';
import '../../core/localstorage/ImportController.dart';
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

  void _rebuildAlbums(void a) {

    TableAlbum.selectAll().then((value) {

      setState(() {
        albums.clear();
        albums.addAll(value);
      });
    });
  }

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onAlbumCacheRebuild.listen(_rebuildAlbums),
    ];

    _rebuildAlbums(null);
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
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                TableAlbum.generateAlbums().whenComplete(() => setState((){}));
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
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: albums.length,
                    itemBuilder: (context, index) {

                      final playlist = albums[index];

                      Future<File?> imageFileFuture;

                      if(playlist.songs.firstOrNull?.pictureCacheKey != null) {
                        imageFileFuture = ImageCacheController.getImagePathFromRaw(playlist.songs.firstOrNull!.pictureCacheKey!);
                      } else {
                        imageFileFuture = Future<File?>.value(null);
                      }

                      return InkWell(
                        child: GridTile(
                          footer: Container(
                            color: Colors.black.withOpacity(0.7), // Background color for the entire GridTileBar
                            child: GridTileBar(
                              title: Text(
                                playlist.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                formatDuration(playlist.duration),
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_arrow),
                                onPressed: () async {
                                  logging.finest(playlist);
                                  AudioController.queuePlaylist(playlist);
                                  await AudioController.playQueue();
                                },
                              ),
                            ),
                          ),
                          child: FutureBuilder<File?>(
                              future: imageFileFuture,
                              builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                                var albumArtImage = snapshot.data != null
                                    ? Image.file(snapshot.data!, fit: BoxFit.cover)
                                    : const Icon(Icons.music_note);
                                return albumArtImage;
                              }),
                        ),
                        onTap: () {
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => PlaylistContextDialog(playlistContext: playlist,),
                          );
                        },
                      );
                    },
                  )
              )
          ],
        ) ,

        drawer: const SettingsDrawer()
    );
  }
}
