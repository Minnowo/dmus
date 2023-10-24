import 'package:dmus/core/data/MusicFetcher.dart';
import 'package:dmus/ui/widgets/SettingsDrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  static const String TITLE = "Songs";
  static List<Song> songs = [];

  @override
  void initState() {
    super.initState();

    MusicFetcher().getAllMusic().then((value) => value.forEach((element) {
          songs.add(element);
        }));
  }

  void addSong(BuildContext context) {
    debugPrint("Adding new song");
  }

  void openMenu(BuildContext context) {
    debugPrint("Opening menu");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(TITLE),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => addSong(context),
              icon: Icon(Icons.add),
            ),
          ],
        ),
        body: Center(
            child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  var song = songs[index];

                  return GestureDetector(
                    child: Container(
                      child: ListTile(
                        title: Text(song.displayTitle),
                        subtitle: Text(song.duration.toString()),
                      ),
                    ),
                  );
                })),
        drawer: SettingsDrawer());
  }
}
