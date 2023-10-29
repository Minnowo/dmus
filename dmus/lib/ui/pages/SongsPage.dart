import 'package:dmus/core/Util.dart';
import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/data/MusicFetcher.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/ui/dialogs/ImportDialog.dart';
import 'package:dmus/ui/dialogs/SongContextDialog.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
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

class _SongsPage extends  StatefulWidget {

  SongsPage parent;

  _SongsPage(this.parent);

  @override
  State<_SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<_SongsPage> {

  @override
  Widget build(BuildContext context) {

    var songsModel = context.watch<SongsModel>();

    debugPrint("Rebuilding stuff: length of songsModel sonogs ${songsModel.songs.length}");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.parent.title),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => showDialog(context: context, builder: (BuildContext context) => const ImportDialog()).whenComplete(songsModel.update),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                songsModel.update();
                debugPrint(DatabaseController.instance.database.toString());
              },
              icon: const Icon(Icons.update),
            ),
            IconButton(
              onPressed: () {
                TableSong.selectAllWithMetadata().then((value) => null);
                AudioController.instance.stopAndEmptyQueue();
              },
              icon: const Icon(Icons.stop),
            ),
            IconButton(
              onPressed: () {
                MusicFetcher.files.clear();
                songsModel.update();
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(songsModel.songs.isEmpty)
              const Center(
                child: Text("Nothing is here!\nHit the + in the top right to import music.", textAlign: TextAlign.center,),)

            else
              Expanded(
                  child:ListView.builder(
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
                              await AudioController.instance.playSong(song);
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
        drawer: SettingsDrawer());
  }
}
