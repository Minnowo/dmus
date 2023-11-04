import 'package:dmus/core/Util.dart';
import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/ui/dialogs/context/SongContextDialog.dart';
import 'package:dmus/ui/dialogs/picker/ImportDialog.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/SongsPageModel.dart';
import 'NavigationPage.dart';


class SongsPage extends NavigationPage {

  const SongsPage({super.key}) : super(icon: Icons.music_note, title: "Songs");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SongsModel(),
      child: _SongsPage(this),
    );
  }
}

class _SongsPage extends StatelessWidget {

  final SongsPage parent;

  const _SongsPage(this.parent);

  @override
  Widget build(BuildContext context) {

    var songsModel = context.watch<SongsModel>();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(parent.title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => showDialog(context: context, builder: (BuildContext context) => const ImportDialog()),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                songsModel.update();
              },
              icon: const Icon(Icons.update),
            ),
            IconButton(
              onPressed: () {
                TableSong.selectAllWithMetadata().then((value) => null);
                AudioController.stopAndEmptyQueue();
              },
              icon: const Icon(Icons.stop),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(songsModel.songs.isEmpty)
              const Center(
                child: Text("Nothing is here!\nHit the + in the top right to import music.",
                    textAlign: TextAlign.center
                ),
              )

            else
              Expanded(
                  child: ListView.builder(
                      itemCount: songsModel.songs.length,
                      itemBuilder: (context, index) {
                        var song = songsModel.songs[index];

                        return InkWell(
                            child: ListTile(
                              title: Text(song.title),
                              trailing: Text(formatDuration(song.duration)),
                              subtitle: Text(subtitleFromMetadata(song.metadata)),
                            ),
                            onTap: () async {
                              debugPrint("Playing tapped");
                              await AudioController.playSong(song);
                            },
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => SongContextDialog(songContext: song,),
                              );
                            }
                        );
                      })
              )
          ],
        ) ,
        endDrawerEnableOpenDragGesture: true,
        drawer: const SettingsDrawer());
  }
}

