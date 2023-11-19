import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../pages/SelectedPlaylistPage.dart';

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
              onTap: () => _playPlaylist(context, playlistContext) ),
          ListTile(
            title: Text(DemoLocalizations.of(context).queueAll),
            onTap: () => _queuePlaylist(context, playlistContext),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).close),
            onTap: () => popNavigatorSafe(context),
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

  void _showPlaylistDetails(BuildContext context) {

    popNavigatorSafe(context);
    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlistContext));
  }
}
