import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(DemoLocalizations.of(context).viewDetails),
            onTap: () => _showPlaylistDetails(context),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).playNow),
            onTap: () => _playPlaylist(context, playlistContext) ),
          ListTile(
            title: Text(DemoLocalizations.of(context).queueAll),
             onTap: () => _queuePlaylist(context, playlistContext),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).editPlaylist),
            onTap: () => _editPlaylist(context, playlistContext),
          ),
          ListTile(
            title: const Text("Delete Playlists"),
            onTap: () => _deletePlaylist(context, playlistContext),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).close),
            onTap: () {
              popNavigatorSafe(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _playPlaylist(BuildContext context, Playlist p) async {

    popNavigatorSafe(context);
    await JustAudioController.instance.stopAndEmptyQueue();
    await JustAudioController.instance.queuePlaylist(playlistContext);
    await JustAudioController.instance.playSongAt(0);
    await JustAudioController.instance.play();;
  }

  void _queuePlaylist(BuildContext context, Playlist p) {

    popNavigatorSafe(context);
    JustAudioController.instance.queuePlaylist(p);
  }

  void _editPlaylist(BuildContext context, Playlist p) {

    popNavigatorSafe(context);
    editPlaylist(context, p);
  }

  void _showPlaylistDetails(BuildContext context) {

    popNavigatorSafe(context);
    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlistContext));
  }

  Future<void> _deletePlaylist(BuildContext context,Playlist p) async {

    popNavigatorSafe(context);

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
}
