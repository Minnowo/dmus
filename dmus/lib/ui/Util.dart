

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:flutter/material.dart';

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

SnackBar createSimpleSnackBar(String text) {

  final snackBar = SnackBar( content: Text(text),);

  return snackBar;
}

SnackBar createSimpleSnackBarWithDuration(String text, Duration d) {

  final snackBar = SnackBar( content: Text(text), duration: d,);

  return snackBar;
}

SnackBar createSnackBar(SnackBarData data) {

  final snackBar = SnackBar(
    content: Text(data.text),
    duration: data.duration ?? const Duration(seconds: 4),
    backgroundColor: data.color,
  );

  return snackBar;
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
