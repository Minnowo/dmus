



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/data/UIEnumSettings.dart';
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
  final SongListWidgetLead leadWith;
  final SongListWidgetTrail trailWith;

  const SongListWidget({
    super.key,
    required this.song,
    required this.selected,
    required this.confirmDismiss,
    required this.onTap,
    required this.leadWith,
    required this.trailWith,
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
          leading: getLeadWith(context),
          title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => SongContextDialog.showAsDialog(context, song),
            child: getTrailWith(context),
          ),
          subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
          selected: selected,
          selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
    );
  }

  Widget getTrailWith(BuildContext context){
    switch(trailWith){

      case SongListWidgetTrail.trailWithDuration:
        return Text(formatDuration(song.duration));

      case SongListWidgetTrail.trailWithMenu:
        return InkWell(
          onTap: () => SongContextDialog.showAsDialog(context, song),
          child: const Icon(Icons.more_vert),
        );
    }
  }
  Widget getLeadWith(BuildContext context){
    switch(leadWith) {

      case SongListWidgetLead.leadWithArtwork:
        return SizedBox(
          width: THUMB_SIZE,
          child: ArtDisplay(dataEntity: song),
        );
      case SongListWidgetLead.leadWithTrackNumber:
        return Text(song.metadata.trackNumber?.toString() ?? "N/A");
    }
  }
}