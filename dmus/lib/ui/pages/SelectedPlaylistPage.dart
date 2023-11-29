import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';


import '../../core/Util.dart';
import '../../core/audio/ProviderData.dart';
import '../Util.dart';
import '../dialogs/Util.dart';
import '../dialogs/context/SongContextDialog.dart';
import '../lookfeel/Theming.dart';
import '../widgets/CurrentlyPlayingBar.dart';

class SelectedPlaylistPage extends StatelessWidget {
  static const String title = "Playlist";

  final Playlist playlistContext;

  const SelectedPlaylistPage({Key? key, required this.playlistContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: THUMB_SIZE,
          leading: Padding(
              padding: const EdgeInsets.only(left: HORIZONTAL_PADDING),
              child: SizedBox(
                  width: THUMB_SIZE,
                  child: Center(child:  IconButton(
                    icon: const Icon(Icons.expand_more_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  )
              )
          )
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(width: HORIZONTAL_PADDING),

                getRoundedCornerContainerImage(context, playlistContext, THUMB_SIZE * 2),

                const SizedBox(width: HORIZONTAL_PADDING),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(playlistContext.title, style: TEXT_BIG,),
                    ],
                  )
                ),

                const SizedBox(width: HORIZONTAL_PADDING),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    const SizedBox(width: HORIZONTAL_PADDING),

                    Text( playlistContext.basicInfoTextWithSep(" - ") , style: TEXT_SUBTITLE,),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Consumer<PlayerStateExtended>(
                        builder: (context, playerState, child){

                          return IconButton(
                            icon: playPauseIcon(context, playerState.playing),
                            onPressed: () async {

                              if(playerState.playing) {
                                await JustAudioController.instance.pause();
                              } else {
                                await JustAudioController.instance.playPlaylist(playlistContext);
                              }
                            },
                          );
                        }
                    ),

                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: () => _letUserUpdatePlaylist(context)

                    ),

                  ],
                ),
              ],
            ),

            Expanded(
              child: playlistContext.songs.isEmpty
                  ? _buildEmptyPlaylist(context)
                  : ListView(
                    children: [
                      for(final i in playlistContext.songs)
                        SongListWidget(
                          song: i,
                          selected: false,
                          confirmDismiss: (d) => addToQueueSongDismiss(d, i),
                          onTap: () => JustAudioController.instance.playSong(i),
                          onLongPress: () => SongContextDialog.showAsDialog(context, i),
                          leadWith: playlistContext.entityType == EntityType.album ? SongListWidgetLead.leadWithTrackNumber : SongListWidgetLead.leadWithArtwork,
                          trailWith: SongListWidgetTrail.trailWithDuration,
                        ),
                    ],
                  )

            ),
            const CurrentlyPlayingBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPlaylist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (playlistContext.songs.isNotEmpty)
            SizedBox(
              width: 100,
              height: 100,
              child: ArtDisplay(dataEntity: playlistContext.songs.firstOrNull),
            ),
          const SizedBox(height: 16),
          const Text(
            'Playlist is empty',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16),
          IconButton(
            onPressed: () {
              editPlaylist(context, playlistContext).whenComplete(() => Navigator.pop(context));
            },
            icon: const Icon(Icons.add_circle_sharp, size: 40),
          ),
        ],
      ),
    );
  }


  void _letUserUpdatePlaylist(BuildContext context) {

      updateExistingPlaylist(context, playlistContext)
          .then((value) {

            if(value != null) {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (ctx) => SelectedPlaylistPage(playlistContext: value)));
            }
      });

  }
}
