

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/CurrentlyPlayingPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/Util.dart';
import '../lookfeel/Theming.dart';

class CurrentlyPlayingBar extends  StatelessWidget {
  const CurrentlyPlayingBar({super.key});

  static int _keyValue = 0;

  @override
  Widget build(BuildContext context) {

    bool dontShow = context.select((PlayerStateExtended value) => !value.paused && !value.playing);


    return Visibility(
      visible: !dontShow ,
        child:
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

                  Consumer<PlayerStateExtended>(
                      builder: (context, playerState, child){

                        return IconButton(
                          icon: playerState.playing ? const Icon(Icons.pause) : const Icon(Icons.play_arrow),
                          onPressed: () async {

                            if(playerState.playing) {
                              await JustAudioController.instance.pause();
                            } else {
                              await JustAudioController.instance.play();
                            }
                          },
                        );
                      }
                  ),

                  Expanded(
                    child: Column(
                      children: <Widget>[

                        Consumer<PlayerSong>(
                            builder: (context, playerSong, child) {
                              return SizedBox(
                                height: 20,
                                child: TextScroll(
                                  playerSong.song != null ? currentlyPlayingTextFromMetadata(playerSong.song!) : "NULL",
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

                        Consumer<PlayerPosition>(
                            builder: (context, playerPosition, child) {

                              double progress = playerPosition.position.inMilliseconds.toDouble();

                              if(playerPosition.duration != null && playerPosition.duration!.inMilliseconds != 0) {
                                progress /= playerPosition.duration!.inMilliseconds;
                              }
                              return Column(children: [
                                LinearProgressIndicator( value: progress, ),
                                Text(formatTimeDisplay(playerPosition.position, playerPosition.duration ?? Duration.zero)),
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
      )     ) ;
  }


  void _openCurrentlyPlayingPage(BuildContext context) {

    animateOpenFromBottom(context, const CurrentlyPlayingPage());

  }
}
