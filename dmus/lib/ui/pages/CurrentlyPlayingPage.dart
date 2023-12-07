import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/ui/Constants.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/Util.dart';
import 'package:dmus/ui/dialogs/picker/SpeedModifierPicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:dmus/ui/widgets/LikeButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/data/DataEntity.dart';
import '../lookfeel/CommonTheme.dart';

class CurrentlyPlayingPage extends  StatelessWidget {

  static const String title = "Currently Playing";

  const CurrentlyPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {

    PlayerSong playerSong = context.watch<PlayerSong>();

    if(playerSong.song == null) {
      return const CircularProgressIndicator();
    }

    Song songContext = playerSong.song!;

    return Scaffold(
        appBar: AppBar(
            title: const Text(title),
            centerTitle: true,
            leadingWidth: THUMB_SIZE,
            leading: Padding(
                padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
                child: SizedBox(
                    width: THUMB_SIZE,
                    child: Center(child:  IconButton(
                      icon: const Icon(Icons.expand_more_rounded),
                      onPressed: () => _close(context),
                    ),
                    )
                )
            ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () => ShowShareDialog(context, songContext),
            ),
            IconButton(
              icon: const Icon(Icons.queue_music),
              onPressed: () => _openQueue(context),
            ),
          ],
        ),
        body: SafeArea(
          child: GestureDetector(
            onVerticalDragEnd: (detail){
              if (detail.primaryVelocity! < -GESTURE_SWIPE_SENSITIVITY) {
                _openQueue(context);
              } else if (detail.primaryVelocity! > GESTURE_SWIPE_SENSITIVITY) {
                _close(context);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 720,
                    child: ArtDisplay(dataEntity: songContext, interactiveIcon: true,)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextScroll(
                          songContext.title,
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
                        TextScroll(songContext.artistAlbumText(),
                          mode: TextScrollMode.endless,
                          velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
                          delayBefore: const Duration(milliseconds: 500),
                          pauseBetween: const Duration(milliseconds: 2000),
                          pauseOnBounce: const Duration(milliseconds: 1000),
                          style: TEXT_SUBTITLE,
                          textAlign: TextAlign.left,
                          fadedBorder: true,
                          fadedBorderWidth: 0.02,
                          fadeBorderVisibility: FadeBorderVisibility.auto,
                          intervalSpaces: 30,
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 20,),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    LikeButton(songContext: songContext),

                    IconButton(
                      icon: const Icon(Icons.playlist_add),
                      onPressed: () => selectPlaylistAndAddSong(context, songContext),
                    ),

                    // IconButton(
                    //     icon: const Icon(Icons.share),
                    //     onPressed: () => ShowShareDialog(context, songContext)
                    // ),
                  ],
                ),

                CurrentlyPlayingControlBar(songContext: songContext,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Consumer<PlayerShuffleOrder>(
                      builder: (context, shuffleOrder, child) {
                        return IconButton(
                          icon:  shuffleOrder.after == ShuffleOrder.inOrder ? const Icon(Icons.shuffle) : const Icon(Icons.shuffle_on_outlined),
                          onPressed: JustAudioController.instance.toggleShuffle,
                        );
                      },
                    ),
                    Consumer<PlayerRepeat>(
                      builder: (context, playerRepeat, child) {
                        return IconButton(
                          icon: !playerRepeat.repeat ? const Icon(Icons.repeat) : const Icon(Icons.repeat_on_outlined),
                          onPressed: JustAudioController.instance.toggleRepeat,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.speed),
                      onPressed: () => showDialog(context: context, builder: (ctx) => const SpeedModifierPicker()),
                    ),
                  ],
                ),

                Center(
                  child: SizedBox(
                      width: THUMB_SIZE * 3,
                      height: THUMB_SIZE / 1.5,
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

  void _close(BuildContext context) {

    JustAudioController.instance.clearQueueIfStopped();
    popNavigatorSafe(context);
  }

}
