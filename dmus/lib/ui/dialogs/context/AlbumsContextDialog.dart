import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '/generated/l10n.dart';
import '../../../core/data/DataEntity.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../../widgets/EntityInfoTile.dart';
import '../Util.dart';

class AlbumsContextDialog extends StatelessWidget {
  final Album playlistContext;

  const AlbumsContextDialog({super.key, required this.playlistContext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Wrap(
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
            onTap: () => popNavigatorPlayPlaylist(context, playlistContext)),
        ListTile(
          leading: const Icon(Icons.queue),
          title: Text(S.current.queueAll),
          onTap: () => popNavigatorQueuePlaylist(context, playlistContext),
        ),
        ListTile(
          leading: const Icon(Icons.queue),
          title: Text(S.current.queueAllNext),
          onTap: () => popNavigatorQueuePlaylistNext(context, playlistContext),
        ),
      ],
    ));
  }

  static Future<T?> showAsDialog<T>(BuildContext context, Album album) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => AlbumsContextDialog(playlistContext: album),
    );
  }

  void _showPlaylistDetails(BuildContext context) {
    popNavigatorSafe(context);
    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlistContext));
  }
}
