import 'package:dmus/ui/dialogs/Util.dart';
import 'package:dmus/ui/dialogs/context/PlaylistContextDialog.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../lookfeel/CommonTheme.dart';
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
          height: THUMB_SIZE,
          width: THUMB_SIZE,
          child: ArtDisplay(dataEntity: playlist),
        ),
        title: Text(playlist.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(playlist.basicInfoText()),
        trailing: SizedBox(
            height: THUMB_SIZE,
            width: THUMB_SIZE / 1.5,
            child: InkWell(
              onTap: () => PlaylistContextDialog.showAsDialog(context, playlist),
              child: const Icon(Icons.more_vert),
            )),
        selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
