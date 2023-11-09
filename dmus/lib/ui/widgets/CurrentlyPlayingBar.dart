

import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:dmus/ui/pages/CurrentlyPlayingPage.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../lookfeel/Theming.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  const CurrentlyPlayingBar({super.key});

  static int _keyValue = 0;


  @override
  Widget build(BuildContext context) {

    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    Song? song = audioControllerModel.currentlyPlaying;

    if(song == null || !audioControllerModel.isPlaying && !audioControllerModel.isPaused) {
      return Container();
    }

    var currentSongPosition = audioControllerModel.position;
    var songDuration = audioControllerModel.duration;

    double progress = currentSongPosition.inMilliseconds.toDouble();

    if(songDuration.inMilliseconds != 0) {
      progress /= songDuration.inMilliseconds;
    }

    return
      Dismissible(
        key: ValueKey(_keyValue),
        onDismissed: (_) async {
          _keyValue++;
          await AudioController.stop();
        },
        child:
        InkWell(
            onTap: () => _openCurrentlyPlayingPage(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: !audioControllerModel.isPlaying,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow), // Play button
                      onPressed: () async { await AudioController.resume(); },
                    ),
                  ),
                  Visibility(
                    visible: audioControllerModel.isPlaying,
                    child: IconButton(
                      icon: const Icon(Icons.pause), // Pause button
                      onPressed: () async { await AudioController.pause(); },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          child: Marquee (
                            text: currentlyPlayingTextFromMetadata(song),
                            blankSpace: 20.0,
                            velocity: 30.0,
                          ),
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
            )
        ),
      ) ;
  }


  void _openCurrentlyPlayingPage(BuildContext context) {

    animateOpenFromBottom(context, const CurrentlyPlayingPage());

  }
}
