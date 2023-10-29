

import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  const CurrentlyPlayingBar({super.key});



  @override
  Widget build(BuildContext context) {

    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    if(!audioControllerModel.isPlaying) {
      return Container();
    }

    var currentSongPosition = audioControllerModel.position;
    var songDuration = audioControllerModel.duration;
    var songTitle = audioControllerModel.currentlyPlaying?.title ?? "INVALID";

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
          Expanded(
            child: Text(
              songTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(formatTimeDisplay(currentSongPosition, songDuration)),
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
