import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:text_scroll/text_scroll.dart';


import '../../core/Util.dart';
import '../../core/audio/ProviderData.dart';
import '../dialogs/Util.dart';
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
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.expand_more_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: playlistContext.songs.isNotEmpty
                          ? ArtDisplay(songContext: playlistContext.songs.firstOrNull)
                          : Container(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (playlistContext.songs.isNotEmpty)
                        SizedBox(
                          width: 150,
                          height: 64,
                          child: TextScroll(
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (playlistContext.songs.isNotEmpty)
                            StreamBuilder<PlayerStateExtended>(
                              stream: JustAudioController.instance.onPlayerStateChanged,
                              initialData: PlayerStateExtended(
                                paused: true,
                                playing: false,
                                processingState: ProcessingState.idle,
                              ),
                              builder: (context, snapshot) {
                                final isPlaying = snapshot.data!.playing;

                                return IconButton(
                                  icon: isPlaying
                                      ? const Icon(Icons.pause_circle_filled, size: 40)
                                      : const Icon(Icons.play_circle_filled, size: 40),
                                  onPressed: () async {
                                    if (isPlaying) {
                                      await JustAudioController.instance.pause();
                                    } else {
                                      await JustAudioController.instance.stopAndEmptyQueue();
                                      await JustAudioController.instance.queuePlaylist(playlistContext);
                                      await JustAudioController.instance.playSongAt(0);
                                      await JustAudioController.instance.play();
                                    }
                                  },
                                );
                              },
                            ),
                          const SizedBox(width: 8),
                          if (playlistContext.songs.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.add_circle_sharp, size: 40),
                              onPressed: () => _letUserUpdatePlaylist(context)
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: playlistContext.songs.isEmpty
                  ? _buildEmptyPlaylist(context)
                  : ListView.builder(
                itemCount: playlistContext.songs.length,
                itemBuilder: (context, index) {
                  final Song song = playlistContext.songs[index];

                  return Dismissible(
                    key: Key(song.id.toString()),
                    confirmDismiss: (direction) async {
                      return false;
                    },
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20.0),
                      child: const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.green,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.playlist_add,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      leading: SizedBox(
                        width: THUMB_SIZE,
                        child: ArtDisplay(songContext: song),
                      ),
                      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text(formatDuration(song.duration)),
                      subtitle: Text(subtitleFromMetadata(song.metadata), maxLines: 1, overflow: TextOverflow.ellipsis),
                      onTap: () {
                        _playPlaylistFromIndex(context, index);
                      },
                    ),
                  );
                },
              ),
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
              child: ArtDisplay(songContext: playlistContext.songs.firstOrNull),
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

  Future<void> _playPlaylistFromIndex(BuildContext context, int startIndex) async {
    try {
      await JustAudioController.instance.stopAndEmptyQueue();
      await JustAudioController.instance.queuePlaylist(playlistContext);
      await JustAudioController.instance.playSongAt(startIndex);
      await JustAudioController.instance.play();
    } catch (e) {
      logging.finest('Error playing playlist from index $startIndex: $e');
    }
  }

  void _letUserUpdatePlaylist(BuildContext context) {

      updateExistingPlaylist(context, playlistContext)
          .then((value) {

            if(value != null) {
              Navigator.pushReplacement(context,  MaterialPageRoute(builder: (ctx) => SelectedPlaylistPage(playlistContext: value)));
            }
      });

  }

  void _openQueue(BuildContext context) {
    animateOpenFromBottom(context, const PlayQueuePage());
  }
}
