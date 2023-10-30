
import 'package:dmus/core/audio/AudioTest.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TablePlaylist.dart';
import 'package:dmus/ui/dialogs/PlaylistCreationForm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../model/PlaylistPageModel.dart';
import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends NavigationPage {

  const PlaylistsPage({super.key}) : super(icon: Icons.list, title: "Playlists");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PlaylistModel(),
      child: _PlaylistsPage(this),
    );
  }
}

class _PlaylistsPage extends StatefulWidget {

  final PlaylistsPage parent;

  const _PlaylistsPage(this.parent, {super.key});

  @override
  State<_PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<_PlaylistsPage>
{
  @override
  Widget build(BuildContext context) {


    PlaylistModel playlistModel = context.watch<PlaylistModel>();

    Future<void> createPlaylist(BuildContext context) async {

      PlaylistCreationFormResult? result =  await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PlaylistCreationForm()));

      if(result == null) {
        return;
      }

      await ImportController.createPlaylist(result.title, result.songs);
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.parent.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => createPlaylist(context),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(playlistModel.playlists.isEmpty)
              const Center(
                child: Text("Nothing is here!\nHit the + in the top right to create a playlist.", textAlign: TextAlign.center,),)

            else
              Expanded(
                  child:ListView.builder(
                      itemCount: playlistModel.playlists.length,
                      itemBuilder: (context, index) {
                        var playlist = playlistModel.playlists[index];

                        return InkWell(
                            child: ListTile(
                              title: Text(playlist.title),
                              trailing: Text(formatDuration(playlist.duration)),
                            ),
                            onTap: () {
                              logging.finest(playlist);
                            },
                            onLongPress: () {
                              // showDialog(
                              //   context: context,
                              //   builder: (BuildContext context) => SongContextDialog(songContext: song,),
                              // );
                            }
                        );
                      })
              )
          ],

        ) ,
        drawer: SettingsDrawer()
    );
  }
}
