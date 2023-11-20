



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../Settings.dart';
import '../dialogs/context/SongContextDialog.dart';
import '../lookfeel/Theming.dart';
import 'ArtDisplay.dart';

class SongListWidget extends StatelessWidget {

  final Song song;

  const SongListWidget({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(song.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        JustAudioController.instance.addNextToQueue(song);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${song.title} added to the queue'),
            duration: fastSnackBarDuration,
          ),
        );

        return false;
      },
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(
          Icons.playlist_add,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.green,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.playlist_add,
          color: Colors.white,
        ),
      ),
      child: InkWell(
        onTap: () => JustAudioController.instance.playSong(song),
        onLongPress: () => SongContextDialog.showAsDialog(context, song),
        child: ListTile(
          leading: SizedBox(
            width: THUMB_SIZE,
            child: ArtDisplay(songContext: song),
          ),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: InkWell(
            onTap: () => SongContextDialog.showAsDialog(context, song),
            child: const Icon(Icons.more_vert),
          ),
          subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }

}