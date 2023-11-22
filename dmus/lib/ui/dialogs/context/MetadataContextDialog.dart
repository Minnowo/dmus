import 'package:dmus/core/Util.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
import 'package:dmus/ui/dialogs/form/MetadataSearchForm.dart';
import 'package:dmus/ui/pages/EditMetadataPage.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';
import '../../Util.dart';

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
            title: Text(DemoLocalizations.of(context).editMetadata),
            onTap: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => EditMetadataPage(entity: songContext)))
                  .then((value) {
                logging.info("=wuu================== $value ${value.runtimeType}");
              });
            },
          ),
          ListTile(
            title: Text(DemoLocalizations.of(context).lookupMetadata),
            onTap: () {

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => const MetadataSearchPage()))
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
