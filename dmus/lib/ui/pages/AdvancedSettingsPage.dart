

import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdvancedSettingsPage extends StatelessWidget {
  const AdvancedSettingsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Random Stuff',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            StatefulBuilder(builder: (context, setState)
            => PopupMenuButton<CurrentlyPlayingBarSwipe>(
                  onSelected: (c) => setState(() => SettingsHandler.setCurrentlyPlayingSwipeMode(CurrentlyPlayingBarSwipe.values.indexOf(c))) ,
                  child: ListTile(
                    title: const Text("Currently Playing Bar Swipe Mode"),
                    trailing: Text("${SettingsHandler.currentlyPlayingSwipeMode}"),
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
          ],
        ),
      ),
    );
  }

}