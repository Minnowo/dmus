import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Constants.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/data/UIEnumSettings.dart';
import '../dialogs/context/SongContextDialog.dart';
import 'NavigationPage.dart';


class SongsPage extends  StatelessNavigationPage {

  const SongsPage({super.key}) : super(icon: Icons.music_note, title: "Songs");

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          PopupMenuButton<SongSort>(
            onSelected: context.read<SongsProvider>().sortSongsBy,
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              // Define the items in the menu
              return <PopupMenuEntry<SongSort>>[
                const PopupMenuItem(
                  value: SongSort.byRandom,
                  child: Text('Sort by Random'),
                ),
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

            Consumer<SongsProvider>(
                builder: (context, songsProvider, child) {

                  if(songsProvider.songs.isEmpty) {
                    return Center(
                      child: Text(LocalizationMapper.current.noSongs,
                          textAlign: TextAlign.center
                      ),
                    );
                  }

                  return Expanded(
                      child: ListView (
                        children: [
                          for(final i in songsProvider.songs)
                            SongListWidget(
                              song: i,
                              leadWith: SongListWidgetLead.leadWithArtwork,
                              trailWith: SettingsHandler.songPageTileTrailWith,
                              confirmDismiss: (d) => addToQueueSongDismiss(d, i),
                              onTap: () => playSong(i),
                              onLongPress: () => SongContextDialog.showAsDialog(context, i, SongContextMode.normalMode),
                              selected: false,
                              background: iconDismissibleBackgroundContainer(Theme.of(context).colorScheme.background, Icons.queue),
                            )
                        ],
                      )
                  );
                })
          ]
      ),
      endDrawerEnableOpenDragGesture: true,
      drawer: const SettingsDrawer(),
    );
  }
  
  Future<void> playSong(Song s ) async {
    JustAudioController.instance.setAutofillQueueWhen(FILL_QUEUE_WHEN);
    await JustAudioController.instance.playSong(s, fillQ: true);
  }
}

