

import 'package:dmus/core/data/provider/ThemeProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/UIEnumSettings.dart';
import '../dialogs/Util.dart';
import '../lookfeel/CommonTheme.dart';
import '../widgets/BlueDivider.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationMapper.current.advancedSettings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                LocalizationMapper.current.appearance,
                style: TEXT_HEADER,
              ),
            ),

            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => SwitchListTile(
              title: Text(LocalizationMapper.current.darkMode),
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
                title: Text(LocalizationMapper.current.songsPageLITrail),
                trailing: Text("${songListWidgetTrailToInt(SettingsHandler.songPageTileTrailWith)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<SongListWidgetTrail>>[
                  PopupMenuItem(
                    value: SongListWidgetTrail.trailWithMenu,
                    child: Text(LocalizationMapper.current.trailMenu),
                  ),
                  PopupMenuItem(
                    value: SongListWidgetTrail.trailWithDuration,
                    child: Text(LocalizationMapper.current.trailDuration),
                  ),
                ];
              },
            ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                LocalizationMapper.current.random,
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<CurrentlyPlayingBarSwipe>(
              onSelected: (c) => setState(() => SettingsHandler.setCurrentlyPlayingSwipeMode(c)) ,
              child: ListTile(
                title: Text(LocalizationMapper.current.playBarSwipeMode),
                trailing: Text("${currentlyPlayingBarSwipeToInt(SettingsHandler.currentlyPlayingSwipeMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<CurrentlyPlayingBarSwipe>>[
                  PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToCancel,
                    child: Text(LocalizationMapper.current.swipeStop),
                  ),
                  PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToNextPrevious,
                    child: Text(LocalizationMapper.current.swipeNext),
                  ),
                ];
              },
            ),
            ),


            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<QueueFillMode>(
              onSelected: (c) => setState(() => SettingsHandler.setQueueFillMode(c)) ,
              child: ListTile(
                title: Text(LocalizationMapper.current.queueMode),
                trailing: Text("${queueFillModeToInt(SettingsHandler.queueFillMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<QueueFillMode>>[
                  PopupMenuItem(
                    value: QueueFillMode.fillWithRandom,
                    child: Text(LocalizationMapper.current.fillRandom),
                  ),
                  PopupMenuItem(
                    value: QueueFillMode.fillWithRandomPrioritySameArtist,
                    child: Text(LocalizationMapper.current.fillRandomArtistPriority),
                  ),
                  PopupMenuItem(
                    value: QueueFillMode.neverGenerate,
                    child: Text(LocalizationMapper.current.neverFillQueue),
                  ),
                ];
              },
            ),
            ),


            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:  Text(
                LocalizationMapper.current.developer,
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            ListTile(
              leading: const Icon(Icons.refresh),
              title: Text(LocalizationMapper.current.refreshMetadata),
              onTap: () => refreshMetadata(context),
            ),

            ListTile(
              leading: const Icon(Icons.backup),
              title: Text(LocalizationMapper.current.backupDatabase),
              onTap: () => backupDatabase(context),
            ),

            ListTile(
              leading: const Icon(Icons.notification_add),
              title: Text(LocalizationMapper.current.showSnackBar),
              onTap: () => showSnackBarWithDuration(context, LocalizationMapper.current.snackBarTest, longSnackBarDuration),
            ),
            ListTile(
              leading: const Icon(Icons.notification_add),
              title: Text(LocalizationMapper.current.showErrorSnackBar),
              onTap: () => showSnackBarWithDuration(context, LocalizationMapper.current.errorSnackBarTest, longSnackBarDuration, color: RED),
            ),
          ],
        ),
      ),
    );
  }

}