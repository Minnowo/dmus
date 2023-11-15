

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
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async {
                  logging.finest(playlist);
                  // AudioController.queuePlaylist(playlist);
                  // await AudioController.playQueue();
                },
              ),
            ),
          ),
          child: ArtDisplay(songContext: playlist.songs.firstOrNull,)
      ),
      onTap: ()=> _openPlaylistPage(context, playlist),
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => PlaylistContextDialog(playlistContext: playlist,),
        );
      },
    );
  }



  void _openPlaylistPage(BuildContext context, Playlist playlist) {

    animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlist));

  }

}