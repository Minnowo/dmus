

import 'package:dmus/core/data/provider/ThemeProvider.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
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
        title: const Text('Advanced Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child:  Text(
                'Appearance',
                style: TEXT_HEADER,
              ),
            ),

            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => SwitchListTile(
              title: const Text("Dark Mode"),
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
                title: const Text("Songs Page List Item Trails With"),
                trailing: Text("${songListWidgetTrailToInt(SettingsHandler.songPageTileTrailWith)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<SongListWidgetTrail>>[
                  const PopupMenuItem(
                    value: SongListWidgetTrail.trailWithMenu,
                    child: Text('Trail With Menu'),
                  ),
                  const PopupMenuItem(
                    value: SongListWidgetTrail.trailWithDuration,
                    child: Text('Trail With Duration'),
                  ),
                ];
              },
            ),
            ),


            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child:  Text(
                'Random',
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<CurrentlyPlayingBarSwipe>(
              onSelected: (c) => setState(() => SettingsHandler.setCurrentlyPlayingSwipeMode(c)) ,
              child: ListTile(
                title: const Text("Currently Playing Bar Swipe Mode"),
                trailing: Text("${currentlyPlayingBarSwipeToInt(SettingsHandler.currentlyPlayingSwipeMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<CurrentlyPlayingBarSwipe>>[
                  const PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToCancel,
                    child: Text('Swipe to Stop'),
                  ),
                  const PopupMenuItem(
                    value: CurrentlyPlayingBarSwipe.swipeToNextPrevious,
                    child: Text('Swipe for Next / Previous'),
                  ),
                ];
              },
            ),
            ),


            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<QueueFillMode>(
              onSelected: (c) => setState(() => SettingsHandler.setQueueFillMode(c)) ,
              child: ListTile(
                title: const Text("Queue Fill Mode"),
                trailing: Text("${queueFillModeToInt(SettingsHandler.queueFillMode)}"),
              ),
              itemBuilder: (BuildContext context) {
                // Define the items in the menu
                return <PopupMenuEntry<QueueFillMode>>[
                  const PopupMenuItem(
                    value: QueueFillMode.fillWithRandom,
                    child: Text('Fill With Random'),
                  ),
                  const PopupMenuItem(
                    value: QueueFillMode.fillWithRandomPrioritySameArtist,
                    child: Text('Fill With Random Priority Same Artist'),
                  ),
                ];
              },
            ),
            ),


            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child:  Text(
                'Developer',
                style: TEXT_HEADER,
              ),
            ),
            const BlueDivider(),

            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text("Refresh Metadata"),
              onTap: () => refreshMetadata(context),
            ),

            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text("Backup Database"),
              onTap: () => backupDatabase(context),
            ),
          ],
        ),
      ),
    );
  }

}