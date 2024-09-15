import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import '/generated/l10n.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../../widgets/EntityInfoTile.dart';
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

        EntityInfoTile(entity: playlistContext),

        ListTile(
          leading: const Icon(Icons.details),
          title: Text(S.current.viewDetails),
          onTap: () => _showPlaylistDetails(context),
        ),
        ListTile(
          leading: const Icon(Icons.play_arrow),
          title: Text(S.current.playNow),
          onTap: () => _playPlaylist(context, playlistContext),
        ),
        ListTile(
          leading: const Icon(Icons.queue),
          title: Text(S.current.queueAll),
          onTap: () => _queuePlaylist(context, playlistContext),
        ),
        ListTile(
          leading: const Icon(Icons.edit),
          title: Text(S.current.editPlaylist),
          onTap: () => _editPlaylist(context, playlistContext),
        ),
        ListTile(
          leading: const Icon(Icons.delete_forever),
          title: Text(S.current.deletePlaylist),
          onTap: () => _deletePlaylist(context, playlistContext),
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
    JustAudioController.instance.setAutofillQueueWhen(FILL_QUEUE_NEVER);
    await JustAudioController.instance.playPlaylist(p);
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
      builder: (ctx) => ConfirmDestructiveAction(
        promptText:
        S.current.confirmPlaylistDelete,
        yesText: S.current.deletePlaylist,
        yesTextColor: Colors.red,
        noText: S.current.cancel,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    await ImportController.deletePlaylist(p);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "${S.current.playlistRemoved1} ${p.title} ${S.current.playlistRemoved2}"),
    );
  }
}
