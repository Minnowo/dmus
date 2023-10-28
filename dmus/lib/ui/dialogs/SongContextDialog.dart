import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/data/MusicFetcher.dart';
import 'package:dmus/ui/pages/MetadataPage.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';

class SongContextDialog extends StatelessWidget {

  final Song songContext;

  const SongContextDialog ({required this.songContext, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('View Details'),
            onTap: () async {
              // Handle Option 1
              Navigator.pop(context);

              if(songContext.file.path == null)
                return;


              var m = await getMetadata(songContext.file.path!);

              Navigator.push(context,MaterialPageRoute(builder: (ctxt) => MetadataPage(metadata: m,)));
            },
          ),
          ListTile(
            title: Text('Close'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Add more options as needed
        ],
      ),
    );
  }
}
