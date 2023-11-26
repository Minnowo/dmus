import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
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
    return Wrap(
      children: <Widget>[
          ListTile(
            title: Text(LocalizationMapper.current.viewDetails),
            onTap: () => _showPlaylistDetails(context),
          ),
          ListTile(
              title: Text(LocalizationMapper.current.playNow),
              onTap: () => playPlaylist(context, playlistContext) ),
          ListTile(
            title: Text(LocalizationMapper.current.queueAll),
            onTap: () => queuePlaylist(context, playlistContext),
          ),
          ListTile(
            title: Text(LocalizationMapper.current.close),
            onTap: () => popNavigatorSafe(context),
          ),
        ],
    );
  }

  static Future<T?> showAsDialog<T>(BuildContext context, Album album) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          AlbumsContextDialog(playlistContext: album),
    );
  }

  void _showPlaylistDetails(BuildContext context) {

    popNavigatorSafe(context);
    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlistContext));
  }
}
