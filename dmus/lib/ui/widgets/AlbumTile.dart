

import 'package:dmus/ui/dialogs/Util.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import 'ArtDisplay.dart';

class AlbumTile extends StatelessWidget {

  final Playlist playlist;

  const AlbumTile({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GridTile(
          footer: Container(
            color: Colors.black.withOpacity(0.7), // Background color for the entire GridTileBar
            child: GridTileBar(
              title: Text(
                playlist.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                formatDuration(playlist.duration),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          child: ArtDisplay(songContext: playlist.songs.firstOrNull,)
      ),
      onTap: () => openPlaylistPage(context, playlist),
      onLongPress: () => showPlaylistOrAlbumContextMenu(context, playlist),
    );
  }
}