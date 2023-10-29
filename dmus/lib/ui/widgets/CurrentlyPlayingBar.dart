

import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  const CurrentlyPlayingBar({super.key});



  @override
  Widget build(BuildContext context) {

    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    if(!audioControllerModel.isPlaying && !audioControllerModel.isPaused) {
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
        children: <Widget>[
          Visibility(
            visible: !audioControllerModel.isPlaying,
            child: IconButton(
              icon: const Icon(Icons.play_arrow), // Play button
              onPressed: () async { await AudioController.instance.resume(); },
            ),
          ),
          Visibility(
            visible: audioControllerModel.isPlaying,
            child: IconButton(
              icon: const Icon(Icons.pause), // Pause button
              onPressed: () async { await AudioController.instance.pause(); },
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  songTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                LinearProgressIndicator(
                  value: progress,
                ),
                Text(formatTimeDisplay(currentSongPosition, songDuration)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
