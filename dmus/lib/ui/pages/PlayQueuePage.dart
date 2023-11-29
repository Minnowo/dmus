

import 'dart:async';
import 'dart:collection';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../Util.dart';
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
          leadingWidth: THUMB_SIZE + HORIZONTAL_PADDING,
          leading: Padding(
              padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
              child: SizedBox(
                  width: THUMB_SIZE,
                  child: Center(child:  IconButton(
                    icon: const Icon(Icons.expand_more_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  )
              )
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

    return SongListWidget(
        song: song,
        selected: currentSong,
        confirmDismiss: (d) => songDismiss(d, index),
        onTap: () => songTap(index),
        background: iconDismissibleBackgroundContainer(Colors.red, Icons.delete),
    );
  }

  Widget buildBody(BuildContext context) {

    return Consumer<PlayerSong>(
        builder: (context, playerSong, child) {

          UnmodifiableListView<Song> queue = JustAudioController.instance.queueView;

          if (queue.isEmpty) {
            return const Center(
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
                  buildSongTile(
                      context,
                      queue[i],
                      i,
                      i == playerSong.index && playerSong.song != null && playerSong.song!.id == queue[i].id),
              ],
            ),
          );
        });
  }


  Future<void> songTap(int index) async {
    await JustAudioController.instance.playSongAt(index);
  }

  Future<bool?> songDismiss(DismissDirection d, int index) async {

    if (d != DismissDirection.endToStart) {
      return false;
    }

    await JustAudioController.instance.removeQueueAt(index);
    setState(() { });
    return true;
  }
}