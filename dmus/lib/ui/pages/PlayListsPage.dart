
import 'package:dmus/core/data/provider/PlaylistProvider.dart';
import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/DataEntity.dart';
import '../dialogs/Util.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends StatelessNavigationPage{

  const PlaylistsPage({super.key}) : super(icon: Icons.list, title: "Playlists");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          PopupMenuButton<PlaylistSort>(
            onSelected: context.read<PlaylistProvider>().sortPlaylistsBy,
            icon: const Icon(Icons.sort),
            itemBuilder: (BuildContext context) {
              // Define the items in the menu
              return <PopupMenuEntry<PlaylistSort>>[
                const PopupMenuItem(
                  value: PlaylistSort.byId,
                  child: Text('Sort by ID'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byTitle,
                  child: Text('Sort by Title'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byDuration,
                  child: Text('Sort by Duration'),
                ),
                const PopupMenuItem(
                  value: PlaylistSort.byNumberOfTracks,
                  child: Text('Sort by Number of Tracks'),
                ),
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => createPlaylist(context),
          ),
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Consumer<PlaylistProvider>(
              builder: (context, playlistProvider, child) {

                if (playlistProvider.playlists.isNotEmpty) {
                  return Expanded(
                    child: ListView(
                      children: [
                        for(final i in playlistProvider.playlists)
                          PlaylistListWidget(playlist: i)
                      ],
                    ),
                  );
                }

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "No playlists",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Click to create",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () => createPlaylist(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
        ],
      ),
      drawer: const SettingsDrawer(),
    );
  }
}
