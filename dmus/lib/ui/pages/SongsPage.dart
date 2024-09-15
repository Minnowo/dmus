import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import '/generated/l10n.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
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

  SongsPage({super.key}) : super(icon: Icons.music_note, title: S.current.songs);

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
                PopupMenuItem(
                  value: SongSort.byRandom,
                  child: Text(S.current.sortByRandom),
                ),
                PopupMenuItem(
                  value: SongSort.byId,
                  child: Text(S.current.sortByID),
                ),
                PopupMenuItem(
                  value: SongSort.byTitle,
                  child: Text(S.current.sortByTitle),
                ),
                PopupMenuItem(
                  value: SongSort.byArtist,
                  child: Text(S.current.sortByArtist),
                ),
                PopupMenuItem(
                  value: SongSort.byAlbum,
                  child: Text(S.current.sortByAlbum),
                ),
                PopupMenuItem(
                  value: SongSort.byDuration,
                  child: Text(S.current.sortByDuration),
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
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                        child: Text(S.current.noSongs,
                          textAlign: TextAlign.center
                      ),
                      )
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
                              background: iconDismissibleBackgroundContainer(Theme.of(context).colorScheme.surface, Icons.queue),
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

