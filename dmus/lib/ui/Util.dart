

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:flutter/material.dart';

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


SnackBar createSimpleSnackBar(String text) {

  final snackBar = SnackBar( content: Text(text),);

  return snackBar;
}


SnackBar createTopSnackbar(BuildContext context){

  final snackBar = SnackBar(
    showCloseIcon: true,
    closeIconColor: Colors.white,
    content: Text('your text', textAlign: TextAlign.center),
    dismissDirection: DismissDirection.up,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).size.height - 70, left: 10, right: 10),
  );

  return snackBar;
}

SnackBar createSimpleSnackBarWithDuration(String text, Duration d) {

  final snackBar = SnackBar(
    content: Text(text),
    duration: d,
  );

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


Widget getRoundedCornerContainerImage(BuildContext context, DataEntity entity, double size) {

  if(entity.artPath != null){
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          image: getDataEntityImageAsDecoration(entity)
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
      image: i.image
  );
}
