import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/data/MusicFetcher.dart';
import 'package:dmus/core/localstorage/Database.dart';
import 'package:dmus/ui/dialogs/ImportDialog.dart';
import 'package:dmus/ui/dialogs/SongContextDialog.dart';
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
              onPressed: () => showDialog(context: context, builder: (BuildContext context) => ImportDialog()),
              icon: Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                songsModel.update();
                debugPrint(DatabaseController.instance.database.toString());
              },
              icon: Icon(Icons.update),
            ),
            IconButton(
              onPressed: () {
                AudioController.instance.stopAndEmptyQueue();
              },
              icon: Icon(Icons.stop),
            ),
            IconButton(
              onPressed: () {
                MusicFetcher.files.clear();
                songsModel.update();
              },
              icon: Icon(Icons.delete),
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
                              title: Text(song.displayTitle),
                              trailing: Text('${song.duration}'),
                              subtitle: Text(song.duration.toString()),
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
