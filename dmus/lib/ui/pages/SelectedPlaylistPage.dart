import 'dart:async';
import 'dart:io';

// import 'package:audioplayers/audioplayers.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/ui/Constants.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/SpeedModifierPicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:dmus/ui/widgets/TimeSlider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../lookfeel/Theming.dart';

class SelectedPlaylistPage extends  StatelessWidget {

  static const String title = "Playlist";

  final Playlist playlistContext;

  const SelectedPlaylistPage({super.key, required this.playlistContext});

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          leading: IconButton(
            icon: const Icon(Icons.expand_more_rounded),
            onPressed: () => popNavigatorSafe(context),
          ),
        ),
        body: SafeArea(
          child: GestureDetector(
            onVerticalDragEnd: (detail){
              logging.info(detail);
              if (detail.primaryVelocity! < -GESTURE_SWIPE_SENSITIVITY) {
                _openQueue(context);
              } else if (detail.primaryVelocity! > GESTURE_SWIPE_SENSITIVITY) {
                Navigator.pop(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 128,
                      child: ArtDisplay(songContext: playlistContext.songs.firstOrNull),
                    ),
                     SizedBox(
                        width: 200,
                        height: 64,
                        child:
                            TextScroll(
                              playlistContext.title,
                              mode: TextScrollMode.endless,
                              velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                              delayBefore: const Duration(milliseconds: 500),
                              pauseBetween: const Duration(milliseconds: 2000),
                              pauseOnBounce: const Duration(milliseconds: 1000),
                              style: TEXT_BIG,
                              textAlign: TextAlign.left,
                              fadedBorder: true,
                              fadedBorderWidth: 0.02,
                              fadeBorderVisibility: FadeBorderVisibility.auto,
                              intervalSpaces: 30,
                            ),
                      ),
                  ],
                ),

                const Spacer(flex: 20,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.repeat),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.speed),
                      onPressed: () {
                        showDialog(context: context, builder: (ctx) => const SpeedModifierPicker());
                      },
                    ),
                  ],
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                      child: InkWell(
                        onTap: ()=> _openQueue(context),
                        child: const Icon(
                          Icons.expand_less_rounded,
                        ),
                    )
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }


  void _openQueue(BuildContext context) {

    animateOpenFromBottom(context, const PlayQueuePage());
  }


}
