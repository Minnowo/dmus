
import 'package:dmus/core/audio/AudioTest.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.parent.title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: Container(
            color: Colors.green,
            child: Center(
              child:
              ElevatedButton(onPressed: (){

                StaticAudioTest.playerTestSong();

              }, child: Text("play song"),
              ),
            )),
        drawer: SettingsDrawer()
    );
  }
}
