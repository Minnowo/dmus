
import 'package:flutter/material.dart';

import '../widgets/SettingsDrawer.dart';

class AlbumsPage extends StatefulWidget {


  const AlbumsPage({super.key});

  @override
  State<AlbumsPage> createState() => _AlbumsPageState();
}


class _AlbumsPageState extends State<AlbumsPage>
{

  static const String TITLE = "Albums";

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
