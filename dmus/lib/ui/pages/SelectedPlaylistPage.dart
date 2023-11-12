import 'package:flutter/material.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/ui/widgets/ArtDisplay.dart';
import 'package:dmus/ui/dialogs/picker/SpeedModifierPicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/PlayQueuePage.dart';
import 'package:text_scroll/text_scroll.dart';
import '../../core/Util.dart';
import '../lookfeel/Theming.dart';

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
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: playlistContext.songs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(playlistContext.songs[index].title),
                    subtitle: Text(subtitleFromMetadata(playlistContext.songs[index].metadata)),
                    // Add more details if needed
                  );
                },
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: InkWell(
                  onTap: () => _openQueue(context),
                  child: const Icon(
                    Icons.expand_less_rounded,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openQueue(BuildContext context) {
    animateOpenFromBottom(context, const PlayQueuePage());
  }
}
