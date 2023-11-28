import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/data/DataEntity.dart';
import '../../Util.dart';

class ShareContextDialog extends StatelessWidget {
  final DataEntity dataEntity;

  const ShareContextDialog({Key? key, required this.dataEntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    switch(dataEntity.entityType) {

      case EntityType.song:
        return buildSong(context);
      case EntityType.album:
      case EntityType.playlist:
        return buildPlaylist(context);
    }
  }

  Widget buildSong(BuildContext context) {
    return Wrap(
      children: <Widget>[

        ListTile(
          title: const Text("Share Title"),
          onTap: () => shareTitle(context),
        ),

        ListTile(
          title: const Text("Share Title + More"),
          onTap: () => shareSongTitleAndMore(context),
        ),

        if(dataEntity.artPath != null)
          ListTile(
            title: const Text("Share Picture"),
            onTap: () => shareArtwork(context),
          ),

        ListTile(
          title: Text(LocalizationMapper.current.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }


  Widget buildPlaylist(BuildContext context) {
    return Wrap(
      children: <Widget>[

        ListTile(
          title: const Text("Share Title"),
          onTap: () => shareTitle(context),
        ),

        ListTile(
          title: const Text("Share All Song Titles"),
          onTap: () => sharePlaylistSongs(context),
        ),

        if(dataEntity.artPath != null)
          ListTile(
            title: const Text("Share Picture"),
            onTap: () => shareArtwork(context),
          ),

        ListTile(
          title: Text(LocalizationMapper.current.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  static Future<T?> showAsDialog<T>(BuildContext context, DataEntity entity) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          ShareContextDialog(dataEntity: entity),
    );
  }

  Future<void> shareTitle(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.share(dataEntity.title);
  }

  Future<void> shareSongTitleAndMore(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.share(dataEntity.title);
  }

  Future<void> sharePlaylistSongs(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.share(dataEntity.title);
  }

  Future<void> shareArtwork(BuildContext context) async {

    if(dataEntity.artPath == null) return;

    File? temp = await ImageCacheController.copyToTempWithExtension(dataEntity.artPath!, "jpg");

    if(temp == null) return;

    popNavigatorSafe(context);
    await Share.shareXFiles([XFile(temp.path)]);
  }
}
