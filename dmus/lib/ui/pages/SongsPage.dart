import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';

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

  void _onSongDeletedId(int s) {

    setState(() {
      songs.removeWhere((e) => e.id == s);
    });
  }

  void _onSongDeleted(Song s) {
    _onSongDeletedId(s.id);
  }

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      ImportController.onSongImported.listen(_onSongImported),
      ImportController.onSongDeleted.listen(_onSongDeleted),
      ImportController.onSongDeletedId.listen(_onSongDeletedId)
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
          PopupMenuButton<SongSort>(
            onSelected: sortSongsBy ,
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              // Define the items in the menu
              return <PopupMenuEntry<SongSort>>[
                const PopupMenuItem(
                  value: SongSort.byId,
                  child: Text('Sort by ID'),
                ),
                const PopupMenuItem(
                  value: SongSort.byTitle,
                  child: Text('Sort by Title'),
                ),
                const PopupMenuItem(
                  value: SongSort.byArtist,
                  child: Text('Sort by Artist'),
                ),
                const PopupMenuItem(
                  value: SongSort.byAlbum,
                  child: Text('Sort by Album'),
                ),
                const PopupMenuItem(
                  value: SongSort.byDuration,
                  child: Text('Sort by Duration'),
                ),
              ];
            },
          ),
          IconButton(
            onPressed: () => showDialog(context: context, builder: (BuildContext context) => const ImportDialog()),
            icon: const Icon(Icons.add),
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


  void sortSongsBy(SongSort sort){
    
    switch(sort) {
      case SongSort.byId:
        songs.sort((a, b) => a.id.compareTo(b.id));
      case SongSort.byTitle:
        songs.sort((a, b) => compareNatural(a.title, b.title));
      case SongSort.byArtist:
        songs.sort((a, b) => compareNatural(a.songArtist(), b.songArtist()));
      case SongSort.byAlbum:
        songs.sort((a, b) => compareNatural(a.songAlbum(), b.songAlbum()));
      case SongSort.byDuration:
        songs.sort((a, b) => a.duration.compareTo(b.duration));
    }

    setState(() { });
  }
}

