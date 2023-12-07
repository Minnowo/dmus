

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/CurrentlyPlayingPage.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/Util.dart';
import '../../core/data/UIEnumSettings.dart';
import '../lookfeel/CommonTheme.dart';


class CurrentlyPlayingBar extends  StatelessWidget {

  static int _keyValue = 0;

  const CurrentlyPlayingBar({super.key});


  @override
  Widget build(BuildContext context) {

    bool dontShow = context.select((PlayerStateExtended value) => !value.paused && !value.playing || value.processingState == ProcessingState.completed);

    return Visibility(
        visible: !dontShow ,
        child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Dismissible(
              key: ValueKey(_keyValue),
              confirmDismiss: handleSwipe,
              child: InkWell(
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
            )
        )
    );
  }


  void _openCurrentlyPlayingPage(BuildContext context) {

    animateOpenFromBottom(context, const CurrentlyPlayingPage());
  }


  Future<bool?> handleSwipe(DismissDirection dir) async {

      switch(SettingsHandler.currentlyPlayingSwipeMode) {

        case CurrentlyPlayingBarSwipe.swipeToCancel:
          await JustAudioController.instance.stopAndEmptyQueue();
          _keyValue++;
          return true;

        case CurrentlyPlayingBarSwipe.swipeToNextPrevious:

          switch(dir) {

            case DismissDirection.endToStart:
              await JustAudioController.instance.skipToPrevious();
              return false;

            case DismissDirection.startToEnd:
              await JustAudioController.instance.skipToNext();
              return false;

            case DismissDirection.vertical:
            case DismissDirection.horizontal:
            case DismissDirection.up:
            case DismissDirection.down:
            case DismissDirection.none:
              return false;
          }
      }
  }
}
