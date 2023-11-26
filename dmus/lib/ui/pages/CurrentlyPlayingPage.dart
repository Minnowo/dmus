// import 'package:audioplayers/audioplayers.dart';
import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:dmus/ui/Constants.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/SpeedModifierPicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingControlBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../lookfeel/Theming.dart';

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
                Expanded(
                    flex: 720,
                    child: ArtDisplay(songContext: songContext)
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
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w300,
                          ),
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

                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              songContext.liked ? Icons.favorite : Icons.favorite_border,
                              color: songContext.liked ? Colors.red : null,
                            ),
                            onPressed: () async {

                              songContext.liked = !songContext.liked;

                              if (songContext.liked) {
                                TableLikes.markSongLiked(songContext);
                              } else {
                                TableLikes.markSongNotLiked(songContext);
                              }

                              setState(() { });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.playlist_add),
                            onPressed: () {
                              logging.finest("ADD TO PLAYLIST");
                            },
                          ),
                        ],
                      );
                    }),

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
