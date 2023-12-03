import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/widgets/EntityInfoTile.dart';
import 'package:flutter/material.dart';

import '../../../core/audio/JustAudioController.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';
import '../../../core/localstorage/ImportController.dart';
import '../../Util.dart';
import '../../dialogs/picker/ConfirmDestructiveAction.dart';
import '../../pages/MetadataPage.dart';

class SongContextDialog extends StatelessWidget {
  final Song songContext;

  const SongContextDialog({required this.songContext, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[

        EntityInfoTile(entity: songContext),

        ListTile(
          leading: const Icon(Icons.queue),
          title: const Text("Add to Queue"),
          onTap: () => addQueue(songContext, context),
        ),
        ListTile(
          leading: const Icon(Icons.details),
          title: Text(LocalizationMapper.current.viewDetails),
          onTap: () => showMetadataPage(context),
        ),
        ListTile(
          leading: const Icon(Icons.block),
          title: const Text("Remove Song"),
          onTap: () => deleteSong(songContext, context),
        ),
        ListTile(
          leading: const Icon(Icons.block),
          title: const Text("Remove and block from reimport"),
          onTap: () => removeAndBlock(songContext, context),
        ),
      ],
    );
  }

  static Future<T?> showAsDialog<T>(BuildContext context, Song song) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          SongContextDialog(songContext: song),
    );
  }

  Future<void> showMetadataPage(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctxt) => MetadataPage(entity: songContext)),
    );
  }

  Future<void> addQueue(Song s, BuildContext context) async {
    JustAudioController.instance.addNextToQueue(s);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "${s.title} has been added to the queue"),
    );

    popNavigatorSafe(context);
  }

  Future<void> removeAndBlock(Song s, BuildContext context) async {
    popNavigatorSafe(context);

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => const ConfirmDestructiveAction(
        promptText:
        "Are you sure you want to block this song from the app? It will be skipped when importing again. You can allow it again from the blacklist under settings.",
        yesText: "Block",
        noText: "Keep",
        yesTextColor: Colors.red,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    await ImportController.blockSong(s);
  }

  Future<void> deleteSong(Song s, BuildContext context) async {
    popNavigatorSafe(context);

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => const ConfirmDestructiveAction(
        promptText: "Are you sure you want to remove this song from the app?",
        yesText: "Remove",
        noText: "Keep",
        yesTextColor: Colors.red,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    await ImportController.deleteSong(s);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "Song ${s.title} has been removed from the app"),
    );
  }
}
