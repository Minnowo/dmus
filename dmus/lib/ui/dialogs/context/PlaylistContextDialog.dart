import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../Util.dart';
import '../form/PlaylistCreationForm.dart';

class PlaylistContextDialog extends StatelessWidget {

  final Playlist playlistContext;

  const PlaylistContextDialog({required this.playlistContext, super.key});

  void showPlaylistDetails(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('View Details'),
            onTap: () => showPlaylistDetails(context),
          ),
          ListTile(
            title: const Text('Play Now'),
            onTap: () => AudioController.stopAndEmptyQueue().then((value) => AudioController.queuePlaylist(playlistContext)).then((value) => AudioController.playQueue()).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: const Text('Queue All'),
            onTap: () => AudioController.queuePlaylist(playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: const Text('Edit Playlist'),
            onTap: () => editPlaylist(context, playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: const Text('Close'),
            onTap: () {
              popNavigatorSafe(context);
            },
          ),
          // Add more options as needed
        ],
      ),
    );
  }
}
