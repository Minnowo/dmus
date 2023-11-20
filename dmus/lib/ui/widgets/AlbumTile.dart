

import 'package:dmus/ui/dialogs/context/AlbumsContextDialog.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../dialogs/context/PlaylistContextDialog.dart';
import '../lookfeel/Animations.dart';
import '../pages/SelectedPlaylistPage.dart';
import 'ArtDisplay.dart';

class AlbumTile extends StatelessWidget {

  final Playlist playlist;

  const AlbumTile({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GridTile(
          footer: Container(
            color: Colors.black.withOpacity(0.7), // Background color for the entire GridTileBar
            child: GridTileBar(
              title: Text(
                playlist.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                formatDuration(playlist.duration),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          child: ArtDisplay(songContext: playlist.songs.firstOrNull,)
      ),
      onTap: ()=> _openPlaylistPage(context, playlist),
      onLongPress: () => _showContextMenu(context),
    );
  }


  void _showContextMenu(BuildContext context) {

    if(playlist is Album) {

      showDialog(
          context: context,
          builder: (BuildContext context) =>
              AlbumsContextDialog( playlistContext: playlist as Album)
      );

    } else {

      showDialog(
          context: context,
          builder: (BuildContext context) =>
              PlaylistContextDialog( playlistContext: playlist, onDelete: (){},)
      );
    }
  }
  void _openPlaylistPage(BuildContext context, Playlist playlist) {

    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlist));
  }
}