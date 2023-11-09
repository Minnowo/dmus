


import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';

class ArtDisplay extends StatelessWidget {

  final Song? songContext;

  const ArtDisplay({super.key, required this.songContext});

  Future<File?> getFutureCachePath() {

    Future<File?> imageFileFuture;

    if (songContext != null && songContext!.pictureCacheKey != null) {
      imageFileFuture = ImageCacheController.getImagePathFromRaw(songContext!.pictureCacheKey!);
    } else {
      imageFileFuture = Future<File?>.value(null);
    }

    return imageFileFuture;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: FutureBuilder(
        future: getFutureCachePath(),
        builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {

          if(snapshot.data != null) {
            return Image.file(snapshot.data!, fit: BoxFit.cover);
          }

          return const Icon(Icons.music_note);
        },
      )
    );
  }
}