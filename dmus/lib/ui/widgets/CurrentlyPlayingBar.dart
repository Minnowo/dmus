

import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  @override
  Widget build(BuildContext context) {


    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    var currentSongPosition = audioControllerModel.position;
    var songDuration = audioControllerModel.duration;
    var songTitle = audioControllerModel.currentlyPlaying?.displayTitle ?? "INVALID";

    double progress = currentSongPosition.inMilliseconds.toDouble();

    if(songDuration.inMilliseconds != 0)
      progress /= songDuration.inMilliseconds;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey, // Customize the background color as needed
      ),
      padding: EdgeInsets.all(8.0), // Add padding for better layout
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // Display the current song title
          Text(
            songTitle,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Display the song position and progress bar
          Expanded(
            child: Column(
              children: <Widget>[
                Text(
                  '${currentSongPosition.inMinutes}:${(currentSongPosition.inSeconds % 60).toString().padLeft(2, '0')} / ${songDuration.inMinutes}:${(songDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                ),
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
