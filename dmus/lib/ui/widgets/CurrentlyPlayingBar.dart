

import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  const CurrentlyPlayingBar({super.key});


  String formatTimeDisplay(Duration sp, Duration sd) {

    return '${(sp.inMinutes % 60).toString().padLeft(2, '0')}'
        ':'
        '${(sp.inSeconds % 60).toString().padLeft(2, '0')}'
        ' / '
        '${(sd.inMinutes % 60).toString().padLeft(2, '0')}'
        ':'
        '${(sd.inSeconds % 60).toString().padLeft(2, '0')}'
    ;
  }


  @override
  Widget build(BuildContext context) {

    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    if(!audioControllerModel.isPlaying) {
      return Container();
    }

    var currentSongPosition = audioControllerModel.position;
    var songDuration = audioControllerModel.duration;
    var songTitle = audioControllerModel.currentlyPlaying?.displayTitle ?? "INVALID";

    double progress = currentSongPosition.inMilliseconds.toDouble();

    if(songDuration.inMilliseconds != 0) {
      progress /= songDuration.inMilliseconds;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            songTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text( formatTimeDisplay(currentSongPosition, songDuration) ),
                LinearProgressIndicator(
                  value: progress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
