import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';

class ArtDisplay extends StatelessWidget {
  final DataEntity? dataEntity;
  final bool? interactiveIcon;

  const ArtDisplay({super.key, required this.dataEntity, this.interactiveIcon});

  @override
  Widget build(BuildContext context) {
    Widget picture;

    if (dataEntity == null || dataEntity!.artPath == null) {
      if (interactiveIcon == null || !interactiveIcon!) {
        picture = const Icon(Icons.music_note);
      } else {
        picture = const Material(child: Icon(Icons.music_note));
      }
    } else {
      picture = Image.file(dataEntity!.artPath!, fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        logging.warning("Could not load image for $dataEntity");

        return const Icon(Icons.music_note);
      });
    }

    return AspectRatio(aspectRatio: 1.0, child: picture);
  }
}
