

import 'dart:io';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import '/generated/l10n.dart';
import 'package:dmus/ui/dialogs/picker/FilePicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';

import '../dialogs/picker/ConfirmDestructiveAction.dart';

class BlacklistedFilePage extends StatefulWidget {

  const BlacklistedFilePage({super.key});

  @override
  State<StatefulWidget> createState() => _BlacklistedFilePageState();
}


class _BlacklistedFilePageState extends State<BlacklistedFilePage> {

  List<SelectableDataItem<String>> _blacklistedFiles = [];

  @override
  void initState() {
    super.initState();

    _blacklistedFiles.addAll(TableBlacklist.selectAll().map((e) => SelectableDataItem(e, false, true)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.blacklistPageTitle),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => addFilesToBlacklist(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => deletedSelectedFiles(context),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(_blacklistedFiles.isEmpty)
              Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                    child: Text(
                        S.current.blacklistPageHelperText,
                        textAlign: TextAlign.center
                    ),

                  )
              )

            else
              Expanded(
                  child: ListView (
                    children: [
                      for(final i in _blacklistedFiles)
                        InkWell(
                          child: ListTile(
                            title: Text(i.item),
                            selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
                            selected: i.isSelected,

                          ),
                          onTap: (){
                            i.isSelected = !i.isSelected;
                            setState(() { });
                          },
                        )
                    ],
                  )
              ),
          ]
      ),
      endDrawerEnableOpenDragGesture: true,
    );
  }

  Future<void> deletedSelectedFiles(BuildContext context) async {

    if(_blacklistedFiles.isEmpty) return;

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => ConfirmDestructiveAction(
        promptText:
        S.current.confirmRemoveFromBlacklist,
        yesText: S.current.removeThem,
        noText: S.current.keep,
        yesTextColor: Colors.red,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }


    for(int i = 0; i < _blacklistedFiles.length; i++) {

      if(!_blacklistedFiles[i].isSelected) continue;

      await TableBlacklist.removeFromBlacklist(_blacklistedFiles[i].item);
      _blacklistedFiles.removeAt(i);
      i--;
    }

    setState(() { });
  }

  Future<void> addFilesToBlacklist(BuildContext context) async {

    final List<File>? files = await animateOpenFromBottom(context, const FilePicker(showFileFilter: alwaysTrueFilter));

    if(files == null || files.isEmpty) return;

    for(final i in files){

      await TableBlacklist.addToBlacklist(i.path);
      _blacklistedFiles.add(SelectableDataItem(i.path, false, true));
    }

    setState(() { });
  }

}