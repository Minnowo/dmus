import 'dart:io';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableBlacklist.dart';
import 'package:dmus/ui/dialogs/picker/DataEntityPicker.dart';
import 'package:dmus/ui/dialogs/picker/FilePicker.dart';
import 'package:dmus/ui/lookfeel/Animations.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:flutter/material.dart';

import '/generated/l10n.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';
import '../dialogs/picker/ConfirmDestructiveAction.dart';

class BlacklistedFilePage extends StatefulWidget {
  const BlacklistedFilePage({super.key});

  @override
  State<StatefulWidget> createState() => _BlacklistedFilePageState();
}

class _BlacklistedFilePageState extends State<BlacklistedFilePage> {
  final List<SelectableDataItem<String>> _blacklistedFiles = [];

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
            onPressed: () => addSongsToBlacklist(context),
            icon: const Icon(Icons.playlist_add),
          ),
          IconButton(
            onPressed: () => addFilesToBlacklist(context),
            icon: const Icon(Icons.file_open),
          ),
          IconButton(
            onPressed: () => deletedSelectedFiles(context),
            icon: const Icon(Icons.remove),
          ),
        ],
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        if (_blacklistedFiles.isEmpty)
          Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: Text(S.current.blacklistPageHelperText, textAlign: TextAlign.center),
          ))
        else
          Expanded(
              child: ListView(
            children: [
              for (final i in _blacklistedFiles)
                StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                  return InkWell(
                    child: ListTile(
                      title: Text(i.item),
                      selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
                      selected: i.isSelected,
                    ),
                    onTap: () {
                      i.isSelected = !i.isSelected;
                      setState(() {});
                    },
                  );
                })
            ],
          )),
      ]),
      endDrawerEnableOpenDragGesture: true,
    );
  }

  Future<void> deletedSelectedFiles(BuildContext context) async {
    if (_blacklistedFiles.isEmpty) return;

    bool? result = await showDialog(
      context: context,
      builder: (ctx) => ConfirmDestructiveAction(
        promptText: S.current.confirmRemoveFromBlacklist,
        yesText: S.current.removeThem,
        noText: S.current.keep,
        yesTextColor: Colors.red,
        noTextColor: null,
      ),
    );

    if (result == null || !result) {
      return;
    }

    for (int i = 0; i < _blacklistedFiles.length; i++) {
      if (!_blacklistedFiles[i].isSelected) continue;

      await TableBlacklist.removeFromBlacklist(_blacklistedFiles[i].item);
      _blacklistedFiles.removeAt(i);
      i--;
    }

    setState(() {});
  }

  Future<void> addFilesToBlacklist(BuildContext context) async {
    final List<File>? files = await animateOpenFromBottom(context, const FilePicker(showFileFilter: alwaysTrueFilter));

    if (files == null || files.isEmpty) return;

    for (final i in files) {
      await TableBlacklist.addToBlacklist(i.path);
      _blacklistedFiles.add(SelectableDataItem(i.path, false, true));
    }

    setState(() {});
  }

  Future<void> addSongsToBlacklist(BuildContext context) async {
    final Iterable<Song>? songs = await animateOpenFromBottom(context, const SongPicker());

    if (songs == null || songs.isEmpty) return;

    if (!context.mounted) {
      return;
    }

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

    for (final i in songs) {
      await ImportController.blockSong(i);
      _blacklistedFiles.add(SelectableDataItem(i.file.absolute.path, false, true));
    }

    setState(() {});
  }
}
