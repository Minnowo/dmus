import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/data/MusicFetcher.dart';
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

                    pickMusicFiles().then((value) => value?.forEach((element) {
                      debugPrint(element.path);

                      MusicFetcher.instance.addFile(element);

                    }));

                    Navigator.pop(context);
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