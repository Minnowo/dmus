import 'package:dmus/core/Util.dart';
import '/generated/l10n.dart';
import 'package:dmus/ui/pages/EditMetadataPage.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';

class MetadataContextDialog extends StatelessWidget {

  final Song songContext;

  const MetadataContextDialog({required this.songContext, super.key});

  void showPlaylistDetails(BuildContext context) {

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(S.current.editMetadata),
            onTap: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => EditMetadataPage(entity: songContext)))
                  .then((value) {
                logging.info("=wuu================== $value ${value.runtimeType}");
              });
            },
          ),
          // Add more options as needed
        ],
      ),
    );
  }
}
