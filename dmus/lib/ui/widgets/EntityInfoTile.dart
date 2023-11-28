

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/widgets/LikeButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../dialogs/Util.dart';
import '../lookfeel/Theming.dart';

class EntityInfoTile extends StatelessWidget {

  final DataEntity entity;
  const EntityInfoTile({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
      children: [

        getImage(context),

        const SizedBox(width: 6),

        Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entity.title),
                getSubtitleText(context),
              ],
            )
        ),

        const SizedBox(width: 6),

        getTrailing(context)
      ],
    )
    ) ;
  }


  Widget getImage(BuildContext context) {

    if(entity.artPath != null){
      return Container(
        width: THUMB_SIZE*1.5,
        height: THUMB_SIZE*1.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            image: getDataEntityImageAsDecoration(entity)
        ),
      );
    }

    return const Icon(Icons.music_note);
  }

  Widget getSubtitleText(BuildContext context){

    switch(entity.entityType) {

      case EntityType.song:
        return Text(formatDuration(entity.duration));
      case EntityType.playlist:
      case EntityType.album:
        return Text("${formatDuration(entity.duration)} - ${(entity as Playlist).songs.length} songs");
    }
  }

  Widget getTrailing(BuildContext context){

    return Row(
      children: [

        IconButton(
            onPressed: () => popShowShareDialog(context, entity),
            icon: const Icon(Icons.share)
        ),

        if(entity.entityType == EntityType.song)
          LikeButton(songContext: entity as Song)
      ],
    );
  }
}