

import 'package:dmus/core/data/provider/ThemeProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/UIEnumSettings.dart';
import '../../generated/l10n.dart';
import '../dialogs/Util.dart';
import '../lookfeel/CommonTheme.dart';
import '../widgets/BlueDivider.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.advancedSettings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                S.current.appearance,
                style: TEXT_HEADER,
              ),
            ),

            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => SwitchListTile(
              title: Text(S.current.darkMode),
              onChanged: (c) => setState(() => context.read<ThemeProvider>().setTheme(c)),
              value: context.read<ThemeProvider>().isDarkModeEnabled,
            )
            ),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<SongListWidgetTrail>(
              onSelected: (c) => setState(() {
                SettingsHandler.setSongsPageTrailWith(c);
                context.read<ThemeProvider>().notify();
              }) ,
              child: ListTile(
                title: Text(S.current.songsPageLITrail),
                trailing: Text("${songListWidgetTrailToInt(SettingsHandler.songPageTileTrailWith)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<SongListWidgetTrail>>[
                  PopupMenuItem(
                    value: SongListWidgetTrail.trailWithMenu,
                    child: Text(S.current.trailMenu),
                  ),
                  PopupMenuItem(
                    value: SongListWidgetTrail.trailWithDuration,
                    child: Text(S.current.trailDuration),
                  ),
                ];
              },
            ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                S.current.random,
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<CurrentlyPlayingBarSwipe>(
              onSelected: (c) => setState(() => SettingsHandler.setCurrentlyPlayingSwipeMode(c)) ,
              child: ListTile(
                title: Text(S.current.playBarSwipeMode),
                trailing: Text("${currentlyPlayingBarSwipeToInt(SettingsHandler.currentlyPlayingSwipeMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<CurrentlyPlayingBarSwipe>>[
                  PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToCancel,
                    child: Text(S.current.swipeStop),
                  ),
                  PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToNextPrevious,
                    child: Text(S.current.swipeNext),
                  ),
                ];
              },
            ),
            ),


            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<QueueFillMode>(
              onSelected: (c) => setState(() => SettingsHandler.setQueueFillMode(c)) ,
              child: ListTile(
                title: Text(S.current.queueMode),
                trailing: Text("${queueFillModeToInt(SettingsHandler.queueFillMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<QueueFillMode>>[
                  PopupMenuItem(
                    value: QueueFillMode.fillWithRandom,
                    child: Text(S.current.fillRandom),
                  ),
                  PopupMenuItem(
                    value: QueueFillMode.fillWithRandomPrioritySameArtist,
                    child: Text(S.current.fillRandomArtistPriority),
                  ),
                  PopupMenuItem(
                    value: QueueFillMode.neverGenerate,
                    child: Text(S.current.neverFillQueue),
                  ),
                ];
              },
            ),
            ),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<PlaylistQueueFillMode>(
              onSelected: (c) => setState(() => SettingsHandler.setPlaylistQueueFillMode(c)) ,
              child: ListTile(
                title: Text(S.current.playlistQueueMode),
                trailing: Text("${playlistQueueFillModeToInt(SettingsHandler.playlistQueueFillMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<PlaylistQueueFillMode>>[
                  PopupMenuItem(
                    value: PlaylistQueueFillMode.neverFill,
                    child: Text(S.current.neverFillQueue),
                  ),
                  PopupMenuItem(
                    value: PlaylistQueueFillMode.fillWithRandom,
                    child: Text(S.current.fillRandom),
                  ),
                ];
              },
            ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                S.current.developer,
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            ListTile(
              leading: const Icon(Icons.refresh),
              title: Text(S.current.refreshMetadata),
              onTap: () => refreshMetadata(context),
            ),

            ListTile(
              leading: const Icon(Icons.backup),
              title: Text(S.current.backupDatabase),
              onTap: () => backupDatabase(context),
            ),

            ListTile(
              leading: const Icon(Icons.notification_add),
              title: Text(S.current.showSnackBar),
              onTap: () => showSnackBarWithDuration(context, S.current.snackBarTest, longSnackBarDuration),
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: Text(S.current.showErrorSnackBar),
              onTap: () => showSnackBarWithDuration(context, S.current.errorSnackBarTest, longSnackBarDuration, color: RED),
            ),
          ],
        ),
      ),
    );
  }

}