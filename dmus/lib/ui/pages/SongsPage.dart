import 'dart:async';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/dialogs/context/SongContextDialog.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';

import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
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

    for(final i in songs){
      if(i.id == s.id) {
        return;
      }
    }

    setState(() {
      songs.add(s);
    });
  }

  void _onSongDeleted(Song s) {

    setState(() {
      songs.removeWhere((e) => e.id == s.id);
    });
  }

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onSongImported.listen(_onSongImported),
      ImportController.onSongDeleted.listen(_onSongDeleted)
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
                  child: ListView (
                    children: [
                      for(final i in songs)
                        SongListWidget(song: i)
                    ],
                  )
              ),
          ]
        ),
      endDrawerEnableOpenDragGesture: true,
      drawer: const SettingsDrawer(),
    );
  }




}

