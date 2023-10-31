import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:dmus/ui/pages/MetadataPage.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';

class SongContextDialog extends StatelessWidget {

  final Song songContext;

  const SongContextDialog ({required this.songContext, super.key});
  
  Future<void> showMetadataPage(BuildContext context) async {

    if(songContext.file.path == null) {

      logging.warning("songContext has no valid file path!");

      Navigator.pop(context);

      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (ctxt) => MetadataPage(entity: songContext,)));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('View Details'),
            onTap: () => showMetadataPage(context),
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
