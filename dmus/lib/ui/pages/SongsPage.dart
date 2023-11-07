import 'dart:async';
import 'dart:io';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/cloudstorage/ExternalStorageModel.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/ui/dialogs/context/SongContextDialog.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImageCacheController.dart';
import '../../core/localstorage/ImportController.dart';
import 'NavigationPage.dart';


class SongsPage extends StatefulNavigationPage {

  const SongsPage({super.key}) : super(icon: Icons.music_note, title: "Songs");

  @override
  State<StatefulWidget> createState() => _SongsPageState();
}

class _SongsPageState extends  State<SongsPage> {

  late final List<StreamSubscription> _subscriptions;

  List<Song> songs = [];
  int marqueeIndex = -1;

  void _onSongImported(Song s) {

    if(songs.contains(s)) {
      return;
    }

    setState(() {
      songs.add(s);
    });
  }

  Future<void> _onDismiss(Song s) async {

    await TableSong.deleteSongById(s.id);

    ExternalStorageModel().deleteFileFromExternalStorage(s.file.path);

    setState(() {
      songs.remove(s);
    });
  }

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onSongImported.listen(_onSongImported),
    ];

    TableSong.selectAllWithMetadata().then( (value) {

      setState(() {
        songs.clear();
        songs.addAll(value);
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

  Widget buildSongList(BuildContext context, int index) {

    final Song song = songs[index];

    Future<File?> imageFileFuture;

    if(song.pictureCacheKey != null) {
      imageFileFuture = ImageCacheController.getImagePathFromRaw(song.pictureCacheKey!);
    } else {
      imageFileFuture = Future<File?>.value(null);
    }

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        child: const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          await _onDismiss(song);
          return true;
        }
        return false;
      },
      child: FutureBuilder<File?>(
        future: imageFileFuture,
        builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {

          var albumArtImage = snapshot.data != null
              ? Image.file(snapshot.data!, fit: BoxFit.cover)
              : const Icon(Icons.music_note);


          Widget tile = ListTile(
              leading: albumArtImage,
              title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              trailing: Text(formatDuration(song.duration)),
              subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
            );

          // TODO: marquee on click

          return InkWell(
            child: tile,
            onTap: () async {
              await AudioController.playSong(song);
            },
            onTapCancel: () {
              setState(() {
                marqueeIndex = index;
              });
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => SongContextDialog(songContext: song),
              );
            },
          );
        },
      ),
    );
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
              onPressed: () => showDialog(context: context, builder: (BuildContext context) => const ImportDialog()),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                TableSong.selectAllWithMetadata().then((value) => null);
                AudioController.stopAndEmptyQueue();
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(songs.isEmpty)
              const Center(
                child: Text("Nothing is here!\nHit the + in the top right to import music.",
                    textAlign: TextAlign.center
                ),
              )

            else
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: buildSongList,
                )
              )
          ],
        ),
      endDrawerEnableOpenDragGesture: true,
      drawer: const SettingsDrawer(),
    );
  }
}

