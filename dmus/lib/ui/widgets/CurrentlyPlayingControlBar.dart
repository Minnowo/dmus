

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../model/AudioControllerModel.dart';
import 'TimeSlider.dart';

class CurrentlyPlayingControlBar extends StatelessWidget {

  final Song? songContext;

  const CurrentlyPlayingControlBar({super.key, this.songContext});


  @override
  Widget build(BuildContext context) {
    return Consumer<AudioControllerModel>(
      builder: (context, audioControllerModel, child) {
        final songDuration = audioControllerModel.duration;
        final songPosition = audioControllerModel.position;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.skip_previous,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    logging.finest("PREVIOUS SONG");
                    // await AudioController.playPrevious();

                  },
                ),
                IconButton(
                  icon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Icon(
                        audioControllerModel.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    if (audioControllerModel.isPlaying) {
                      // await AudioController.pause();
                    } else {
                      if(songContext != null) {
                        // await AudioController.resumeOrPlay(songContext!);
                      } else {
                        // await AudioController.resumePlayLast();
                      }
                    }
                  },
                ),
                IconButton(
                  icon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.stop,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    // await AudioController.stop();
                  },
                ),
                IconButton(
                  icon: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.skip_next,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    logging.finest(" NEXT SONG");
                    // await AudioController.playNext();
                  },
                ),
              ],
            ),

            TimeSlider(songDuration: songDuration, songPosition: songPosition),
          ],
        );
      },
    );
  }




}