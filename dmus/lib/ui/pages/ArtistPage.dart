
import 'package:dmus/core/data/provider/ArtistProvider.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import '/generated/l10n.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:dmus/ui/widgets/AlbumTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/SettingsDrawer.dart';

class ArtistPage extends StatelessNavigationPage {

  ArtistPage({super.key}) : super(icon: Icons.art_track, title: S.current.artists);

  static String onEmptyText = S.current.artistsAppear;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
          actions: const [

            IconButton(
                onPressed: ImportController.rebuildArtists,
                icon: Icon(Icons.refresh)
            )
          ],
        ),
        body:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Consumer<ArtistProvider>(
              builder: (context, albumProvider, child) {

                if(albumProvider.albums.isEmpty) {
                  return Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                          child: Text(onEmptyText, textAlign: TextAlign.center,)
                      )
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
