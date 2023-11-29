



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
  final bool selected;
  final Future<bool?> Function(DismissDirection) confirmDismiss;
  final Future<void> Function() onTap;
  final Future<void> Function()? onLongPress;
  final Widget? background;
  final Widget? secondaryBackground;

  const SongListWidget({
    super.key,
    required this.song,
    required this.selected,
    required this.confirmDismiss,
    required this.onTap,
    this.onLongPress,
    this.background,
    this.secondaryBackground
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: confirmDismiss,
      background: background,
      secondaryBackground: secondaryBackground,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: ListTile(
          leading: SizedBox(
            width: THUMB_SIZE,
            child: ArtDisplay(dataEntity: song),
          ),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: InkWell(
            onTap: () => SongContextDialog.showAsDialog(context, song),
            child: const Icon(Icons.more_vert),
          ),
          subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
          selected: selected,
          selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }
}