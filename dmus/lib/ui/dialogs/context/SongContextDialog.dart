import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
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

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (ctxt) => MetadataPage(entity: songContext,)));
  }


  Future<void> addQueue(Song s, BuildContext context) async
  {
    JustAudioController.instance.addNextToQueue(s);

    MessagePublisher.publishSnackbar(SnackBarData(text: "${s.title} has been added to the queue"));

    popNavigatorSafe(context);
  }


  Future<void> deleteSong(Song s,BuildContext context) async {

    await TableSong.deleteSongById(s.id);

    ExternalStorageModel().deleteFileFromExternalStorage(s.file.path);

    onDelete();

    popNavigatorSafe(context);

    MessagePublisher.publishSnackbar(SnackBarData(text: "Song ${s.title} has been removed from the app"));
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
