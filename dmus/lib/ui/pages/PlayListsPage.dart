
import 'package:flutter/material.dart';

import '../widgets/SettingsDrawer.dart';
import 'NavigationPage.dart';

class PlaylistsPage extends NavigationPage {

  const PlaylistsPage({super.key}) : super(icon: Icons.list, title: "Playlists");

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}


class _PlaylistsPageState extends State<PlaylistsPage>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
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
