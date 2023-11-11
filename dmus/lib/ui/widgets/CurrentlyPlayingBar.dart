

import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
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

    // AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    // Song? song = audioControllerModel.currentlyPlaying;

    // if(song == null || !audioControllerModel.isPlaying && !audioControllerModel.isPaused) {
    //   return Container();
    // }


    return
      Dismissible(
        key: ValueKey(_keyValue),
        onDismissed: (_) async {
          _keyValue++;
          await JustAudioController.instance.stop();
        },
        child:
        InkWell(
            onTap: () => _openCurrentlyPlayingPage(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Visibility(
                    visible: true,
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow), // Play button
                      onPressed: () async {
                        // await AudioController.resume();
                        },
                    ),
                  ),
                  // Visibility(
                  //   visible: audioControllerModel.isPlaying,
                  //   child: IconButton(
                  //     icon: const Icon(Icons.pause), // Pause button
                  //     onPressed: () async {
                  //       // await AudioController.pause();
                  //       },
                  //   ),
                  // ),
                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Consumer<PlayerIndex>(
                            builder:(context, playerIndex, child) {

                              return SizedBox(
                                height: 20,
                                child: TextScroll(
                                  playerIndex.index?.toString() ?? "No index 1029310398103948102381023981029381203842342342342342343",
                                  mode: TextScrollMode.endless,
                                  velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                                  delayBefore: const Duration(milliseconds: 500),
                                  pauseBetween: const Duration(milliseconds: 2000),
                                  pauseOnBounce: const Duration(milliseconds: 1000),
                                  style: TEXT_SMALL_HEADLINE,
                                  textAlign: TextAlign.left,
                                  fadedBorder: true,
                                  fadedBorderWidth: 0.02,
                                  fadeBorderVisibility: FadeBorderVisibility.auto,
                                  intervalSpaces: 30,
                                ),
                              );
                            }),

                        Consumer2<PlayerPosition, PlayerDuration>(
                            builder: (context, playerPosition, playerDuration, child) {

                              double progress = playerPosition.position.inMilliseconds.toDouble();

                              if(playerDuration.duration != null && playerDuration.duration!.inMilliseconds != 0) {
                                progress /= playerDuration.duration!.inMilliseconds;
                              }
                              return Column(children: [
                                LinearProgressIndicator( value: progress, ),
                                Text(formatTimeDisplay(playerPosition.position, playerDuration.duration ?? Duration.zero)),
                              ],
                              );
                            }
                        ),
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
