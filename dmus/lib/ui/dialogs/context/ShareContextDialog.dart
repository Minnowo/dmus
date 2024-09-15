import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import '/generated/l10n.dart';
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
          title: Text(S.current.shareFile),
          onTap: () => shareFile(context),
        ),

        ListTile(
          title: Text(S.current.shareTitle),
          onTap: () => shareTitle(context),
        ),

        ListTile(
          title: Text(S.current.shareTitlePlus),
          onTap: () => shareSongTitleAndMore(context),
        ),

        if(dataEntity.artPath != null)
          ListTile(
            title: Text(S.current.sharePicture),
            onTap: () => shareArtwork(context),
          ),

      ],
    );
  }


  Widget buildPlaylist(BuildContext context) {
    return Wrap(
      children: <Widget>[

        ListTile(
          title: Text(S.current.shareTitle),
          onTap: () => shareTitle(context),
        ),

        ListTile(
          title: Text(S.current.shareAllSongs),
          onTap: () => sharePlaylistSongs(context),
        ),

        ListTile(
          title: Text(S.current.shareAllMore),
          onTap: () => sharePlaylistSongsAndMore(context),
        ),

        if(dataEntity.artPath != null)
          ListTile(
            title: Text(S.current.sharePicture),
            onTap: () => shareArtwork(context),
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

  Future<void> shareFile(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.shareXFiles([XFile((dataEntity as Song).file.path)]);
  }
  Future<void> shareTitle(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.share(dataEntity.title);
  }

  Future<void> shareSongTitleAndMore(BuildContext context) async {

    popNavigatorSafe(context);
    await Share.share("${dataEntity.title} - ${(dataEntity as Song).artistAlbumText()}");
  }

  Future<void> sharePlaylistSongsAndMore(BuildContext context) async {

    popNavigatorSafe(context);

    Playlist p = dataEntity as Playlist;

    String titles = p.songs.map((e) => "${e.title} - ${e.artistAlbumText()}").reduce((value, element) => "$value\n$element");

    await Share.share(titles);
  }

  Future<void> sharePlaylistSongs(BuildContext context) async {

    popNavigatorSafe(context);

    Playlist p = dataEntity as Playlist;

    String titles = p.songs.map((e) => e.title).reduce((value, element) => "$value\n$element");

    await Share.share(titles);
  }

  Future<void> shareArtwork(BuildContext context) async {

    if(dataEntity.artPath == null) return;

    File? temp = await ImageCacheController.copyToTempWithExtension(dataEntity.artPath!, "jpg");

    if(temp == null) return;

    popNavigatorSafe(context);
    await Share.shareXFiles([XFile(temp.path)]);
  }
}
