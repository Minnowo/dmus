

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../core/Util.dart';
import '../core/audio/JustAudioController.dart';

void popNavigatorSafe(BuildContext context) {
  if(context.mounted) {
    Navigator.pop(context);
  }
}


void popNavigatorSafeWithArgs<T extends Object>(BuildContext context, [T? result]) {
  if(context.mounted) {
    Navigator.pop(context, result);
  }
}


void showSnackBarWithDuration(BuildContext context, String text, Duration duration, {Color? color}) {

  color ??= Theme.of(context).snackBarTheme.backgroundColor ?? Colors.white12;

  showTopSnackBar(
    Overlay.of(context),
    CustomSnackBar.info(
      icon: const Icon(Icons.info, color: Color.fromARGB(0, 0, 0, 0),),
      backgroundColor: color,
      textStyle: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      message: text,
      maxLines: 3,
    ),
    animationDuration: const Duration(milliseconds: 100),
    reverseAnimationDuration : const Duration(milliseconds: 100),
    displayDuration: duration,
    dismissType: DismissType.onSwipe,
    dismissDirection: [DismissDirection.up, DismissDirection.horizontal],
    curve: Curves.linear,
  );
}

Widget getRoundedCornerContainerImage(BuildContext context, DataEntity entity, double size) {

  if(entity.artPath != null){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          image: getDataEntityImageAsDecoration(entity),
      ),
    );
  }

  return const Icon(Icons.music_note);
}


Icon playPauseIcon(BuildContext context, bool playing){
  return playing ?
  const Icon(Icons.pause) :
  const Icon(Icons.play_arrow);
}


Widget iconDismissibleBackgroundContainer(Color? color, IconData icon) {
  return Container(
    color: color,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Icon(icon),
  );
}


Future<bool> addToQueueSongDismiss(DismissDirection direction, Song song) async
{
  JustAudioController.instance.addNextToQueue(song);

  MessagePublisher.publishSnackbar(
      SnackBarData(
          text: '${song.title} added to the queue',
          duration: fastSnackBarDuration
      )
  );

  return false;
}


DecorationImage? getDataEntityImageAsDecoration(DataEntity dataEntity) {

  if(dataEntity.artPath == null) {
    return null;
  }

  Image i = Image.file(dataEntity.artPath!, fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {

        logging.warning("Could not load image for $dataEntity");

        return const Icon(Icons.music_note);
      });

  return DecorationImage(
      image: i.image,
      fit: BoxFit.cover
  );
}
