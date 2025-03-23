import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/DataEntity.dart';
import 'TimeSlider.dart';

class CurrentlyPlayingControlBar extends StatelessWidget {
  final Song? songContext;

  const CurrentlyPlayingControlBar({super.key, this.songContext});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
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
                      onPressed: JustAudioController.instance.skipToPrevious,
                    ),
                    Consumer<PlayerStateExtended>(builder: (context, playerState, child) {
                      return IconButton(
                        icon: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Icon(
                              playerState.playing && !playerState.paused ? Icons.pause : Icons.play_arrow,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (playerState.playing && !playerState.paused) {
                            await JustAudioController.instance.pause();
                          } else {
                            await JustAudioController.instance.play();
                          }
                        },
                      );
                    }),
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
                      onPressed: JustAudioController.instance.stop,
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
                      onPressed: JustAudioController.instance.skipToNext,
                    ),
                  ],
                ),
                Consumer<PlayerPosition>(
                  builder: (context, playerPosition, child) => TimeSlider(
                      songDuration: playerPosition.duration ?? Duration.zero, songPosition: playerPosition.position),
                ),
              ],
            )));
  }
}
