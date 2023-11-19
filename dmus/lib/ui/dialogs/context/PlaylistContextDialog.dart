import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../Util.dart';
import '../form/PlaylistCreationForm.dart';
import '../picker/ConfirmDestructiveAction.dart';

class PlaylistContextDialog extends StatelessWidget {

  final Playlist playlistContext;
  final VoidCallback onDelete;

  const PlaylistContextDialog({required this.playlistContext, super.key, required this.onDelete});

  void showPlaylistDetails(BuildContext context) {
    // Navigate to the SelectedPlaylistPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedPlaylistPage(playlistContext: playlistContext),
      ),
    );
  }

  Future<void> deletePlaylist(BuildContext context,Playlist p) async {

    bool? result = await showDialog(
        context: context,
        builder: (ctx) => const ConfirmDestructiveAction(
            promptText: "Are you sure you want to delete this playlist? This action cannot be undone.",
          yesText: "Delete Playlist?",
          yesTextColor: Colors.red,
          noText: "No",
          noTextColor: Colors.green,
        ));

    if(result == null || !result) {
      return;
    }

    await TablePlaylist.deletePlaylist(p.id);

    onDelete();

    MessagePublisher.publishSnackbar(SnackBarData(text: "Playlist ${p.title} has been removed from the app"));
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
            onTap: () {
              Navigator.pop(context); // Pop the Navigator immediately
              JustAudioController.instance.stopAndEmptyQueue()
                  .then((value) => JustAudioController.instance.queuePlaylist(playlistContext))
                  .then((value) => JustAudioController.instance.playSongAt(0))
                  .then((value) => JustAudioController.instance.play());
            },
          ),

          ListTile(
            title: Text(DemoLocalizations.of(context).queueAll),
             onTap: () => JustAudioController.instance.queuePlaylist(playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).editPlaylist),
            onTap: () => editPlaylist(context, playlistContext).whenComplete(() => popNavigatorSafe(context)),
          ),
          ListTile(
            title: Text("Delete Playlists"),
            onTap: (){ deletePlaylist(context, playlistContext).whenComplete(() => popNavigatorSafe(context));
            }
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
