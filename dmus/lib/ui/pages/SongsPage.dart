import 'dart:async';
import 'dart:io';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/cloudstorage/ExternalStorageModel.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/dialogs/context/SongContextDialog.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:flutter/material.dart';

import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImageCacheController.dart';
import '../../core/localstorage/ImportController.dart';
import '../lookfeel/Animations.dart';
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

  // Future<void> _onDismiss(Song s) async {
  //
  //   await TableSong.deleteSongById(s.id);
  //   if (s.file.path!=null)
  //   {
  //     ExternalStorageModel().deleteFileFromExternalStorage(s.file.path);
  //   }
  //
  //
  //   setState(() {
  //     songs.remove(s);
  //   });
  // }

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

    return Dismissible(
      key: Key(song.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {

        JustAudioController.instance.addNextToQueue(song);


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${song.title} added to the queue'),
            duration: const Duration(milliseconds: 90),
          ),
        );

        return false;
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(
          Icons.playlist_add,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.playlist_add,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: () async {
          await JustAudioController.instance.playSong(song);
          await JustAudioController.instance.play();
        },
        onLongPress: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => SongContextDialog(
              songContext: song,
              onDelete: () {
                setState(() {
                  songs.remove(song);
                });
              },
            ),
          );
        },
        child: ListTile(
          leading: SizedBox(
            width: THUMB_SIZE,
            child: ArtDisplay(songContext: song),
          ),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(formatDuration(song.duration)),
          subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
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
              onPressed: () async {
                await TableSong.selectAllWithMetadata();
                await JustAudioController.instance.stop();
                // AudioController.stopAndEmptyQueue();
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(songs.isEmpty)
              Center(
                child: Text(DemoLocalizations.of(context).noSongs,
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

