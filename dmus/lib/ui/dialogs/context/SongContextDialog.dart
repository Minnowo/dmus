import 'package:dmus/ui/widgets/EntityInfoTile.dart';
import 'package:flutter/material.dart';

import '/generated/l10n.dart';
import '../../../core/audio/JustAudioController.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';
import '../../../core/localstorage/ImportController.dart';
import '../../Util.dart';
import '../../dialogs/picker/ConfirmDestructiveAction.dart';
import '../../pages/MetadataPage.dart';

enum SongContextMode {
  normalMode,
  queueMode,
}

class SongContextDialog extends StatelessWidget {
  final Song songContext;
  final SongContextMode mode;
  final int? currentSongQueueIndex;

  const SongContextDialog({super.key, required this.songContext, required this.mode, this.currentSongQueueIndex});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        EntityInfoTile(entity: songContext),
        if (mode == SongContextMode.normalMode)
          ListTile(
            leading: const Icon(Icons.queue),
            title: Text(S.current.addToQueue),
            onTap: () => addQueue(songContext, context),
          ),
        ListTile(
          leading: const Icon(Icons.details),
          title: Text(S.current.viewDetails),
          onTap: () => showMetadataPage(context),
        ),
        if (mode == SongContextMode.queueMode && currentSongQueueIndex != null)
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(S.current.removeQueue),
            onTap: () => removeQueueAt(currentSongQueueIndex!, context),
          ),
        if (mode == SongContextMode.normalMode)
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(S.current.removeSong),
            onTap: () => deleteSong(songContext, context),
          ),
        if (mode == SongContextMode.normalMode)
          ListTile(
            leading: const Icon(Icons.block),
            title: Text(S.current.removeAndBlock),
            onTap: () => removeAndBlock(songContext, context),
          ),
      ],
    );
  }

  static Future<T?> showAsDialog<T>(BuildContext context, Song song, SongContextMode mode,
      {int? currentSongIndex}) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SongContextDialog(
        songContext: song,
        mode: mode,
        currentSongQueueIndex: currentSongIndex,
      ),
    );
  }

  Future<void> showMetadataPage(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (ctxt) => MetadataPage(entity: songContext)),
    );
  }

  Future<void> removeQueueAt(int index, BuildContext context) async {
    JustAudioController.instance.removeQueueAt(index);

    popNavigatorSafe(context);
  }

  Future<void> addQueue(Song s, BuildContext context) async {
    JustAudioController.instance.addNextToQueue(s);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "${s.title} ${S.current.titleAddedToQueue}"),
    );

    popNavigatorSafe(context);
  }

  Future<void> removeAndBlock(Song s, BuildContext context) async {
    popNavigatorSafe(context);

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => ConfirmDestructiveAction(
        promptText: S.current.confirmBlockSong,
        yesText: S.current.block,
        noText: S.current.keep,
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
      builder: (ctx) => ConfirmDestructiveAction(
        promptText: S.current.confirmRemoveSong,
        yesText: S.current.remove,
        noText: S.current.keep,
        yesTextColor: Colors.red,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    await ImportController.deleteSong(s);

    MessagePublisher.publishSnackbar(
        SnackBarData(text: "${S.current.songRemoved1} ${s.title} ${S.current.songRemoved2}"));
  }
}
