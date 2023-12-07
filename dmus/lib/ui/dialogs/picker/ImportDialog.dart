import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/dialogs/picker/FilePicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/pages/YoutubeImportPage.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../Util.dart';

class ImportDialog extends StatelessWidget {
  const ImportDialog({super.key});


  Future<void> pickFilesAndImport(BuildContext context) async {

    popNavigatorSafe(context);

    final value = await animateOpenFromBottom<List<File>?>(context, const FilePicker(showFileFilter: hasMusicFileExtension,));

    if(value == null) return;

    await ImportController.importSongs(value);
  }

  Future<void> pickFolderAndImport(BuildContext context) async {

    popNavigatorSafe(context);

    final value = await pickDirectory();

    if(value == null) return;

    Directory d = Directory(value);

    logging.info("About to import files from $d");

    await ImportController.importSongFromDirectory(d, true, true);
  }

  Future<void> youtubeImport(BuildContext context) async {

    popNavigatorSafe(context);

    await animateOpenFromBottom(context, const YoutubeImportPage());
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
              onPressed: () => youtubeImport(context),
              child: Text("YouTube"),
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