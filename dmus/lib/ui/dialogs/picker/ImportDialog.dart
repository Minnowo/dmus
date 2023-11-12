import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../Util.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});


  void pickFilesAndImport(BuildContext context) {

    pickMusicFiles()
        .then((value) async {

          if(value == null) return;

          for(var f in value) {

            if(f.path == null) continue;

            await ImportController.importSong(File(f.path!));
          }

          await ImportController.endImports();
    });

    // (not an error) Pop as soon as we open the above dialog
    popNavigatorSafe(context);
  }

  void pickFolderAndImport(BuildContext context) {

    pickDirectory()
        .then((value) async {

          if(value == null) return;

          Directory d = Directory(value);

          logging.info("About to import files from $d");

          await ImportController.importSongFromDirectory(d, true);
    });

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
                  child: Text(DemoLocalizations.of(context).addFiles)
                ),
                TextButton(
                  onPressed: () => pickFolderAndImport(context) ,
                  child: Text(DemoLocalizations.of(context).addFolder),
                )
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(DemoLocalizations.of(context).close),
            ),
          ],
        ),
      ),
    );
  }
}