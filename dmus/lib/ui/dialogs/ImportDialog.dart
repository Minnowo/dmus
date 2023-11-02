import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../Util.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});


  // TODO: Get rid of this and handle it in ImportController
  Future<void> doImportFromDir(String dir) async {

  }

  void pickFilesAndImport(BuildContext context) {

    pickMusicFiles()
        .then((value) async {

          if(value == null) return;

          for(var f in value) {

            if(f.path == null) continue;

            await ImportController.importSong(File(f.path!));
          }
    });

    // (not an error) Pop as soon as we open the above dialog
    popNavigatorSafe(context);
  }

  void pickFolderAndImport(BuildContext context) {

    pickDirectory()
        .then((value) => value != null ? doImportFromDir(value) : null);

    // (not an error) Pop as soon as we open the above dialog
    popNavigatorSafe(context);
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
                  onPressed: () => pickFilesAndImport(context),
                  child: const Text('Add Files')
                ),
                TextButton(
                  onPressed: () => pickFolderAndImport(context) ,
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