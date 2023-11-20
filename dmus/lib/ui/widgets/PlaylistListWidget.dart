



import 'package:dmus/ui/dialogs/Util.dart';
import 'package:dmus/ui/dialogs/context/PlaylistContextDialog.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../lookfeel/Theming.dart';
import 'ArtDisplay.dart';

class PlaylistListWidget extends StatelessWidget {

  final Playlist playlist;

  const PlaylistListWidget({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => openPlaylistPage(context, playlist),
        onLongPress: () => PlaylistContextDialog.showAsDialog(context, playlist),
        child: ListTile(
          leading: SizedBox(
            width: THUMB_SIZE,
            child: ArtDisplay(songContext: playlist.songs.firstOrNull),
          ),
          title: Text(playlist.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: InkWell(
            onTap: () => PlaylistContextDialog.showAsDialog(context, playlist),
            child: const Icon(Icons.more_vert),
          ),
        ),
    );
  }

}