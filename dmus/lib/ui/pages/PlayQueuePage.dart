

import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../widgets/ArtDisplay.dart';

class PlayQueuePage extends StatefulWidget {

  static const String QUEUE_EMPTY_TEXT = "The queue is empty!";

  const PlayQueuePage({super.key});


  @override
  State<StatefulWidget> createState()=> _PlayQueuePageState();

}

class _PlayQueuePageState extends State<PlayQueuePage> {

  late final List<StreamSubscription> _subscriptions;

  void _onSongChanged(Song? song) {

      setState(() { });
  }

  @override
  void initState() {

    super.initState();

    _subscriptions = [
      // AudioController.onSongChanged.listen(_onSongChanged),
    ];
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
            leading:SizedBox(
              width: THUMB_SIZE,
              child: Center(child:  IconButton(
                icon: const Icon(Icons.expand_more_rounded),
                onPressed: () => Navigator.pop(context),
              ),)
            )
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildBody(context),

            const CurrentlyPlayingControlBar()
          ],
        ),
    );
  }

  Widget buildSongTile(BuildContext context, Song song, int index, bool currentSong) {

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
          return true;
        }
        return false;
      },
      child: Container(
        color: currentSong ? Colors.red : null,
        child: InkWell(
          child: ListTile(
            leading: SizedBox (
              width: THUMB_SIZE,
              child: ArtDisplay(songContext: song,),
            ),
            title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text(formatDuration(song.duration)),
            subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          onTap: () async {
            // await AudioController.playSongAt(index);
          },
        ),
      )
    );
  }

  Widget buildBody(BuildContext context) {

    UnmodifiableListView<Song> queue = JustAudioController.instance.queueView;
    logging.finest(queue);

    if (queue.isEmpty) {
      return Center(
        child: Text(
          PlayQueuePage.QUEUE_EMPTY_TEXT,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Expanded(
      child: ListView(
        children: [
          for (int i = 0; i < queue.length; i++)
            buildSongTile(context, queue[i], i, i == false),
        ],
      ),
    );
  }

}