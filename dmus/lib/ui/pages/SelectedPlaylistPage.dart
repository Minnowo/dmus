import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/widgets/SongListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/audio/ProviderData.dart';
import '../../core/data/UIEnumSettings.dart';
import '../../core/localstorage/SettingsHandler.dart';
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

            Container(
              color: Theme.of(context).colorScheme.background,
              child: Row(
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
                ],
              ),
            ),

            Container(
              color: Theme.of(context).colorScheme.background,
              child: Row(
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

                      Consumer2<QueueChanged, PlayerStateExtended>(
                        builder: (context, queueChanged, playerStateExtended, child) =>
                            IconButton(
                                icon: playPauseIcon(context, queueChanged.lastPlaylistIsQueue == playlistContext.songsHashCode() && playerStateExtended.playing),
                                onPressed: () async {

                                  if(queueChanged.lastPlaylistIsQueue == playlistContext.songsHashCode()) {
                                    if(playerStateExtended.playing) {
                                      await JustAudioController.instance.pause();
                                    } else {
                                      await JustAudioController.instance.play();
                                    }
                                  } else {
                                    await JustAudioController.instance.playPlaylist(playlistContext);
                                  }
                                }
                            ),
                      ),

                      IconButton(
                          icon: const Icon(Icons.queue),
                          onPressed: () => JustAudioController.instance.queuePlaylist(playlistContext)
                      ),

                      IconButton(
                          icon: const Icon(Icons.copy),
                          onPressed: () => createPlaylistFrom(context, playlistContext.songs).whenComplete(() => Navigator.pop(context))
                      ),

                      if(playlistContext.entityType != EntityType.album)
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _letUserUpdatePlaylist(context)

                        ),
                    ],
                  ),
                ],
              ),
            ),


            Expanded(
              child: playlistContext.songs.isEmpty
                  ? _buildEmptyPlaylist(context)
                  :

              Consumer<PlayerSong>(
                  builder: (context, playerSong, child) =>
                      ListView.builder(
                      itemCount: playlistContext.songs.length,
                      itemBuilder: (context, i) {
                        Song s = playlistContext.songs[i];
                        return SongListWidget(
                          song: s,
                          selected: (JustAudioController.instance.lastPlaylistInQueue == playlistContext.songsHashCode() && s.id == playerSong.song?.id && i == playerSong.index) ||
                                    (JustAudioController.instance.lastPlaylistInQueue != playlistContext.songsHashCode() && s.id == playerSong.song?.id),
                          confirmDismiss: (d) => addToQueueSongDismiss(d, s),
                          background: iconDismissibleBackgroundContainer(Theme.of(context).colorScheme.background, Icons.queue),
                          onTap: () => JustAudioController.instance.playPlaylistStartingFrom(playlistContext, i),
                          onLongPress: () => SongContextDialog.showAsDialog(context, s),
                          leadWith: playlistContext.entityType ==
                              EntityType.album ? SongListWidgetLead.leadWithTrackNumber : SongListWidgetLead.leadWithArtwork,
                          trailWith: SongListWidgetTrail.trailWithDuration,
                        );
                      }
                  )
              ),
            ),
            const CurrentlyPlayingBar()
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
