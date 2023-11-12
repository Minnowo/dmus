import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/pages/MetadataPage.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/cloudstorage/ExternalStorageModel.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/localstorage/dbimpl/TableSong.dart';

class SongContextDialog extends StatelessWidget {

  final Song songContext;
  final VoidCallback onDelete;
  const SongContextDialog ({required this.songContext, Key? key, required this.onDelete}) : super(key: key);


  Future<void> showMetadataPage(BuildContext context) async {

    if(songContext.file.path == null) {

      logging.warning("songContext has no valid file path!");

      Navigator.pop(context);

      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (ctxt) => MetadataPage(entity: songContext,)));
  }

  Future<void> addQueue(Song s,BuildContext context) async
  {
    JustAudioController.instance.addNextToQueue(s);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Song added to queue'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context); // Close the menu
  }


  Future<void> deleteSong(Song s,BuildContext context) async {
    await TableSong.deleteSongById(s.id);
    if (s.file.path != null) {
      ExternalStorageModel().deleteFileFromExternalStorage(s.file.path);
    }

    onDelete();
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Song deleted'),
        duration: Duration(seconds: 1),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text("Add to Queue"),
            onTap: () => addQueue(songContext,context),

          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).viewDetails),
            onTap: () => showMetadataPage(context),
          ),
          ListTile(
            title: Text("Delete Song"),
            onTap: () => deleteSong(songContext,context),


          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).close),
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
