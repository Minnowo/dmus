
import 'package:dmus/core/data/musicbrainz/SearchAPI.dart';
import 'package:dmus/ui/dialogs/MetadataSearchForm.dart';
import 'package:dmus/ui/model/AlbumsPageModel.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/data/musicbrainz/ReleaseResponseData.dart';
import '../widgets/SettingsDrawer.dart';

class AlbumsPage extends NavigationPage {

  const AlbumsPage({super.key}) : super(icon: Icons.album, title: "Albums");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AlbumModel(),
      child: _AlbumsPage(this),
    );
  }
}

class _AlbumsPage extends StatefulWidget {

  final AlbumsPage parent;

  const _AlbumsPage(this.parent, {super.key});

  @override
  State<_AlbumsPage> createState() => _AlbumsPageState();
}


class _AlbumsPageState extends State<_AlbumsPage>
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
        body: ElevatedButton(
          child: Text("open dialog"),
          onPressed: () async {

            await Navigator.push(context, MaterialPageRoute(builder: (ctx) => MetadataSearchPage()));
          },
        ),
        drawer: SettingsDrawer()
    );
  }
}
