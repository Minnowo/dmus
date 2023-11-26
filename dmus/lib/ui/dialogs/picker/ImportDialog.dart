import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/dialogs/picker/FilePicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../Util.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});


  void pickFilesAndImport(BuildContext context) {

    popNavigatorSafe(context);

    animateOpenFromBottom<List<File>?>(context, const FilePicker(showFileFilter: hasMusicFileExtension,))
        .then((value) async {

          if(value == null) return;

          await ImportController.importSongs(value);
    });
  }

  void pickFolderAndImport(BuildContext context) {

    pickDirectory()
        .then((value) async {

          if(value == null) return;

          Directory d = Directory(value);

          logging.info("About to import files from $d");

          await ImportController.importSongFromDirectory(d, true, true);
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
            TextButton(
              onPressed: () => pickFilesAndImport(context),
              child: Text(LocalizationMapper.current.addFiles)
            ),
            TextButton(
              onPressed: () => pickFolderAndImport(context) ,
              child: Text(LocalizationMapper.current.addFolder),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(LocalizationMapper.current.close),
            ),
          ],
        ),
      ),
    );
  }
}