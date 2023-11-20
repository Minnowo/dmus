import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../pages/SelectedPlaylistPage.dart';
import '../Util.dart';

class AlbumsContextDialog extends StatelessWidget {

  final Album playlistContext;

  const AlbumsContextDialog({super.key, required this.playlistContext});

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
              onTap: () => playPlaylist(context, playlistContext) ),
          ListTile(
            title: Text(DemoLocalizations.of(context).queueAll),
            onTap: () => queuePlaylist(context, playlistContext),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).close),
            onTap: () => popNavigatorSafe(context),
          ),
        ],
      ),
    );
  }


  void _showPlaylistDetails(BuildContext context) {

    popNavigatorSafe(context);
    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlistContext));
  }
}
