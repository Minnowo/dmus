
import 'package:flutter/material.dart';

import '../widgets/SettingsDrawer.dart';

class PlaylistsPage extends StatefulWidget {


  const PlaylistsPage({super.key});

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}


class _PlaylistsPageState extends State<PlaylistsPage>
{

  static const String TITLE = "Playlists";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(TITLE),
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
          child: const Center(
            child: Text('Page 2',
                style: TextStyle(fontSize: 24, color: Colors.white)),
          ),
        ),
        drawer: SettingsDrawer()
    );
  }
}
