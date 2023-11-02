import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';

class PlaylistContextDialog extends StatelessWidget {

  final Playlist plylistContext;

  const PlaylistContextDialog({required this.plylistContext, super.key});

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
            onTap: () => AudioController.stopAndEmptyQueue().then((value) => AudioController.queuePlaylist(plylistContext)).then((value) => AudioController.playQueue()).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: const Text('Queue All'),
            onTap: () => AudioController.queuePlaylist(plylistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text('Close'),
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
