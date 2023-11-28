import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/context/ShareContextDialog.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../Util.dart';
import '../picker/ConfirmDestructiveAction.dart';

class PlaylistContextDialog extends StatelessWidget {
  final Playlist playlistContext;

  const PlaylistContextDialog({Key? key, required this.playlistContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text(LocalizationMapper.current.viewDetails),
          onTap: () => _showPlaylistDetails(context),
        ),
        ListTile(
          title: Text(LocalizationMapper.current.playNow),
          onTap: () => _playPlaylist(context, playlistContext),
        ),
        ListTile(
          title: Text(LocalizationMapper.current.queueAll),
          onTap: () => _queuePlaylist(context, playlistContext),
        ),
        ListTile(
          title: Text(LocalizationMapper.current.editPlaylist),
          onTap: () => _editPlaylist(context, playlistContext),
        ),
        ListTile(
          title: Text(LocalizationMapper.current.shareButton),
          onTap: () => popShowShareDialog(context, playlistContext),
        ),
        ListTile(
          title: const Text("Delete Playlist"),
          onTap: () => _deletePlaylist(context, playlistContext),
        ),
        ListTile(
          title: Text(LocalizationMapper.current.close),
          onTap: () => popNavigatorSafe(context),
        ),
      ],
    );
  }

  static Future<T?> showAsDialog<T>(BuildContext context, Playlist p) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          PlaylistContextDialog(playlistContext: p),
    );
  }

  Future<void> _playPlaylist(BuildContext context, Playlist p) async {
    popNavigatorSafe(context);
    await JustAudioController.instance.stopAndEmptyQueue();
    await JustAudioController.instance.queuePlaylist(playlistContext);
    await JustAudioController.instance.playSongAt(0);
    await JustAudioController.instance.play();
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
    animateOpenFromBottom(
        context, SelectedPlaylistPage(playlistContext: playlistContext));
  }

  Future<void> _deletePlaylist(BuildContext context, Playlist p) async {
    popNavigatorSafe(context);

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => const ConfirmDestructiveAction(
        promptText:
        "Are you sure you want to delete this playlist?",
        yesText: "Delete Playlist",
        yesTextColor: Colors.red,
        noText: "Cancel",
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    await ImportController.deletePlaylist(p);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "Playlist ${p.title} has been removed from the app"),
    );
  }
}
