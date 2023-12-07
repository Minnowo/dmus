
import 'package:dmus/core/data/provider/PlaylistProvider.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/widgets/PlaylistListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/DataEntity.dart';
import '../dialogs/Util.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends StatelessNavigationPage{

  PlaylistsPage({super.key}) : super(icon: Icons.list, title: LocalizationMapper.current.playlists);

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
                PopupMenuItem(
                  value: PlaylistSort.byId,
                  child: Text(LocalizationMapper.current.sortByID),
                ),
                PopupMenuItem(
                  value: PlaylistSort.byTitle,
                  child: Text(LocalizationMapper.current.sortByTitle),
                ),
                PopupMenuItem(
                  value: PlaylistSort.byDuration,
                  child: Text(LocalizationMapper.current.sortByDuration),
                ),
                PopupMenuItem(
                  value: PlaylistSort.byNumberOfTracks,
                  child: Text(LocalizationMapper.current.sortByNumberOfTracks),
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
                      Text(
                        LocalizationMapper.current.noPlaylists,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        LocalizationMapper.current.clickToCreate,
                        style: const TextStyle(fontSize: 16),
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
