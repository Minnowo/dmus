
import 'package:dmus/core/data/provider/AlbumProvider.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:dmus/ui/widgets/AlbumTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/SettingsDrawer.dart';

class AlbumsPage extends StatelessNavigationPage {

  const AlbumsPage({super.key}) : super(icon: Icons.album, title: "Albums");

  static const String onEmptyText = "Albums will appear as you import music!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Consumer<AlbumProvider>(
              builder: (context, albumProvider, child) {

                if(albumProvider.albums.isEmpty) {
                  return const Center(
                      child: Text(onEmptyText, textAlign: TextAlign.center,)
                  );
                }

                return Expanded(
                    child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: albumProvider.albums.length,
                        itemBuilder: (context, index) => AlbumTile(playlist: albumProvider.albums[index])
                    )
                );
              },
            )
          ],
        ) ,

        drawer: const SettingsDrawer()
    );
  }
}
