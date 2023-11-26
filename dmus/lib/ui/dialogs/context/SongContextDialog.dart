import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/ConfirmDestructiveAction.dart';
import 'package:dmus/ui/pages/MetadataPage.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/cloudstorage/ExternalStorageModel.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/localstorage/dbimpl/TableSong.dart';

class SongContextDialog extends StatelessWidget {

  final Song songContext;

  const SongContextDialog ({required this.songContext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text("Add to Queue"),
            onTap: () => addQueue(songContext,context),
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).viewDetails),
            onTap: () => showMetadataPage(context),
          ),
          ListTile(
            title: const Text("Remove Song"),
            onTap: () => deleteSong(songContext,context),
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text("Remove and block from reimport"),
            onTap: () => removeAndBlock(songContext,context),
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


  static Future<T?> showAsDialog<T>(BuildContext context, Song song) async {

    return showDialog( context: context, builder: (BuildContext context) => SongContextDialog( songContext: song) );
  }


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


  Future<void> removeAndBlock(Song s,BuildContext context) async {

    popNavigatorSafe(context);

    bool? result = await showDialog(
        context: context,
        builder: (ctx) => const ConfirmDestructiveAction(
          promptText: "Are you sture you want to block this song from the app? It will be skipped when importing again. You can remove it from the blacklist under settings.",
          yesText: "Block",
          noText: "Keep",
          yesTextColor: Colors.red,
          noTextColor: null,
        )
    );

    if(result == null || !result){
      return;
    }

    await ImportController.blockSong(s);
  }


  Future<void> deleteSong(Song s,BuildContext context) async {

    popNavigatorSafe(context);

    bool? result = await showDialog(
        context: context,
        builder: (ctx) => const ConfirmDestructiveAction(
          promptText: "Are you sure you want to remove this song from the app?",
          yesText: "Remove",
          noText: "Keep",
          yesTextColor: Colors.red,
          noTextColor: null,
        )
    );

    if(result == null || !result){
      return;
    }

    await ImportController.deleteSong(s);

    MessagePublisher.publishSnackbar(SnackBarData(text: "Song ${s.title} has been removed from the app"));
  }
}
