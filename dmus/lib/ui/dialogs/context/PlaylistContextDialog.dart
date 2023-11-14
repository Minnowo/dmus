import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../Util.dart';
import '../form/PlaylistCreationForm.dart';

class PlaylistContextDialog extends StatelessWidget {

  final Playlist playlistContext;

  const PlaylistContextDialog({required this.playlistContext, super.key});

  void showPlaylistDetails(BuildContext context) {
    // Navigate to the SelectedPlaylistPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedPlaylistPage(playlistContext: playlistContext),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(DemoLocalizations.of(context).viewDetails),
            onTap: () => showPlaylistDetails(context),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).playNow),
            // onTap: () => AudioController.stopAndEmptyQueue().then((value) => AudioController.queuePlaylist(playlistContext)).then((value) => AudioController.playQueue()).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).queueAll),
            // onTap: () => AudioController.queuePlaylist(playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).editPlaylist),
            onTap: () => editPlaylist(context, playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).close),
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
