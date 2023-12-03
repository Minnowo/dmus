

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/widgets/LikeButton.dart';
import 'package:flutter/material.dart';

import '../dialogs/Util.dart';
import '../lookfeel/CommonTheme.dart';

class EntityInfoTile extends StatelessWidget {

  final DataEntity entity;
  const EntityInfoTile({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
      children: [

        getRoundedCornerContainerImage(context, entity, THUMB_SIZE * 1.5),

        const SizedBox(width: 6),

        Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entity.title),
                Text(entity.basicInfoText()),
              ],
            )
        ),

        const SizedBox(width: 6),

        getTrailing(context)
      ],
    )
    ) ;
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