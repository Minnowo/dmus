import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/data/MusicFetcher.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:flutter/material.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Add Files'),
                  onPressed: () {

                    pickMusicFiles()
                        .then((value) => value
                        ?.where((e) => e.path != null)
                        .forEach((element) => TableSong.insertSong(File(element.path!))))
                        .then((value) => Navigator.pop(context));
                  },
                ),
                TextButton(
                  onPressed: () {

                    pickDirectory().then((value) => value?? debugPrint(value));
                    Navigator.pop(context);
                  },
                  child: const Text('Add Folder'),
                )
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}