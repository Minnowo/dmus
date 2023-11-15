


import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';

class ArtDisplay extends StatelessWidget {

  final Song? songContext;

  const ArtDisplay({super.key, required this.songContext});

  @override
  Widget build(BuildContext context) {

    Widget picture;

    if(songContext == null || songContext!.artPath == null) {
      picture = const Icon(Icons.music_note);
    } else {
      picture = Image.file(songContext!.artPath!, fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {

            logging.warning("Could not load image for $songContext");

            return const Icon(Icons.music_note);
          });
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: picture
    );
  }
}