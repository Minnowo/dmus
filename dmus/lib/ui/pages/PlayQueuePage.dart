import 'dart:async';
import 'dart:collection';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/ui/dialogs/Util.dart';
import 'package:dmus/ui/dialogs/context/SongContextDialog.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/generated/l10n.dart';
import '../../core/data/DataEntity.dart';
import '../../core/data/UIEnumSettings.dart';
import '../Util.dart';
import '../lookfeel/CommonTheme.dart';

class PlayQueuePage extends StatelessWidget {
  static String QUEUE_EMPTY_TEXT = S.current.queueEmpty;

  const PlayQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: THUMB_SIZE + HORIZONTAL_PADDING,
        centerTitle: true,
        leading: Padding(
            padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
            child: SizedBox(
                width: THUMB_SIZE,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.expand_more_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ))),
        title: Consumer2<QueueChanged, QueueShuffle>(
            builder: (context, queueChanged, _, child) =>
                Text("${JustAudioController.instance.queueSize} ${S.current.songs}")),
        actions: [
          IconButton(onPressed: JustAudioController.instance.shuffleQueue, icon: const Icon(Icons.shuffle)),
          IconButton(onPressed: () => createPlaylistFromQueue(context), icon: const Icon(Icons.playlist_add))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [buildBody(context), const CurrentlyPlayingControlBar()],
      ),
    );
  }

  Widget buildSongTile(BuildContext context, Song song, int index, bool currentSong) {
    return SongListWidget(
      song: song,
      leadWith: SongListWidgetLead.leadWithArtwork,
      trailWith: SongListWidgetTrail.trailWithDuration,
      selected: currentSong,
      confirmDismiss: (d) => songDismiss(d, index),
      onTap: () => songTap(index),
      onLongPress: () =>
          SongContextDialog.showAsDialog(context, song, SongContextMode.queueMode, currentSongIndex: index),
      background: iconDismissibleBackgroundContainer(Colors.red, Icons.delete),
    );
  }

  Widget buildBody(BuildContext context) {
    context.select((QueueChanged q) => q.length);

    return Consumer2<PlayerSong, QueueShuffle>(builder: (context, playerSong, _, child) {
      UnmodifiableListView<Song> queue = JustAudioController.instance.queueView;

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
              buildSongTile(
                  context,
                  queue[i],
                  i,
                  i == JustAudioController.instance.queueIndex &&
                      playerSong.song != null &&
                      playerSong.song!.id == queue[i].id),
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

    JustAudioController.instance.removeQueueAt(index);

    return true;
  }
}
