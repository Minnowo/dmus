import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../Util.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});

  Future<void> doImportFromFiles(List<PlatformFile> files) async {

    for(var f in files) {

      if(f.path == null) {
        continue;
      }

      await ImportController.importSong(File(f.path!));
    }
  }

  Future<void> doImportFromDir(String dir) async {

  }

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
                  onPressed: () => pickMusicFiles()
                      .then((value) =>  doImportFromFiles(value ?? [])
                      .whenComplete(() => popNavigatorSafe(context))),
                ),
                TextButton(
                  onPressed: () {
                    pickDirectory().then((value) {
                      if (value != null) {
                        doImportFromDir(value).whenComplete(() => popNavigatorSafe(context));
                      }
                    });                  },
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