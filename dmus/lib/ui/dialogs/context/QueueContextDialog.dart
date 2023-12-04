import 'package:flutter/material.dart';

import '../../../core/audio/JustAudioController.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/data/MessagePublisher.dart';

import '../../../core/localstorage/ImportController.dart';
import '../../Util.dart';
import '../../dialogs/picker/ConfirmDestructiveAction.dart';
import '../../pages/MetadataPage.dart';
import '../../widgets/EntityInfoTile.dart'; // Assuming this is the correct import

class QueueContextDialog extends StatefulWidget {
  final Song songContext;
  final VoidCallback onQueueUpdated;
  final int index;

  const QueueContextDialog({
    required this.songContext,
    required this.index, // Add this line
    required this.onQueueUpdated,
    Key? key,
  }) : super(key: key);


  @override
  State<QueueContextDialog> createState() => _QueueContextDialogState();

  static Future<T?> showAsDialog<T>(BuildContext context, Song song, int index) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          QueueContextDialog(songContext: song, index: index, onQueueUpdated: () {  },),
    );
  }
}

class _QueueContextDialogState extends State<QueueContextDialog> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        EntityInfoTile(entity: widget.songContext),

        ListTile(
          leading: const Icon(Icons.queue),
          title: const Text("Add to Queue"),
          onTap: () => addQueue(widget.songContext, context),
        ),
        ListTile(
          leading: const Icon(Icons.details),
          title: Text("View Details"), // You might want to change this text
          onTap: () => showMetadataPage(context),
        ),
        ListTile(
          leading: const Icon(Icons.block),
          title: const Text("Remove From Queue"),
          onTap: () => removeQueue(widget.index, context,widget.songContext),
        ),


      ],
    );
  }

  Future<void> showMetadataPage(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (ctxt) => MetadataPage(entity: widget.songContext)),
    );
  }

  Future<void> addQueue(Song s, BuildContext context) async {
    JustAudioController.instance.addNextToQueue(s);

    MessagePublisher.publishSnackbar(
      SnackBarData(text: "${s.title} has been added to the queue",duration: const Duration(milliseconds:800)),
    );



    Navigator.pop(context, true);
    Navigator.pop(context, true);
  }


  Future<void> removeQueue(int index, BuildContext context,Song s) async {
    print(JustAudioController.instance.queueView);
    print(index);

    if (index != -1) {
      JustAudioController.instance.removeQueueAt(index);

      MessagePublisher.publishSnackbar(
        SnackBarData(text: "${s.title} has been removed queue", duration: const Duration(milliseconds:800)),
      );

      // Close the dialog
      Navigator.pop(context, true);
      Navigator.pop(context, true);
      widget.onQueueUpdated(); // Call the callback to notify the parent widget

    }
  }
}
