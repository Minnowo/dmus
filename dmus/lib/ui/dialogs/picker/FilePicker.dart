

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/ui/Util.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';

class FilePicker extends StatefulWidget {

  final bool Function(String) showFileFilter;

  const FilePicker({super.key, required this.showFileFilter});

  @override
  State<StatefulWidget> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {

  final List<String> _externalStorageRoots = [];

  int _depth = 0;
  String? _currentDirectory;

  List<SelectableDataItem<FileSystemEntity>> _files = [];

  @override
  void initState() {
    super.initState();

    ExternalPath.getExternalStorageDirectories().then((value) {
      for(final i in value) {
        _externalStorageRoots.add(i);
      }

      if(_externalStorageRoots.isEmpty) {
        MessagePublisher.publishSomethingWentWrong("Cannot find any storage!");
        popNavigatorSafe(context);
        return;
      }
      if(_externalStorageRoots.length == 1) {
        _currentDirectory = _externalStorageRoots.first;
        _depth = 1;
        buildFileCache();
      }

      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pick Files"),
          actions: [
            IconButton(
                onPressed: confirmSelection,
                icon: const Icon(Icons.check)
            )
          ],
        ),
        body: ListView(
          children: [

            if(_depth > 0)
              InkWell(
                  onTap: gotoParent,
                  child: const ListTile(
                    title: Text(".."),
                  )
              ),

            if(_currentDirectory == null)
              for(final d in _externalStorageRoots)
                InkWell(
                  child: ListTile(
                    title: Text(d),
                  )
                  ,onTap: () => setDirectory(d),
                ),

            if(_currentDirectory != null)
              ...buildFileList()

          ],
        ),
        floatingActionButton: FloatingActionButton(
              onPressed: confirmSelection,
              child: const Icon(Icons.check),
            )
      ),
    );
  }


  List<Widget> buildFileList() {

    if(_currentDirectory == null) {
      return [];
    }

    final List<Widget> items = [];

    for(final i in _files) {

      if(!i.isVisible) {

        items.add(
            InkWell(
              child: ListTile(
                title: Text(Path.basename(i.item.path)),
                selected: i.isSelected,
                selectedTileColor: Colors.amber,
              ),
              onTap: (){
                i.isSelected = !i.isSelected;
                logging.info("Item is selected ${i.item}");
                setState(() { });
              },
            ));

        continue;
      }

      items.add(
          InkWell(
            child: ListTile(
              leading: const Icon(Icons.folder),
              title: Text(Path.basename(i.item.path)),
            ),
            onTap: () => setDirectory(i.item.path),
          ));
    }

    return items;
  }

  void confirmSelection() {

    popNavigatorSafeWithArgs<List<File>>(
        context,
        _files
            .where((e) => e.isSelected)
            .map((e) => File(e.item.path))
            .toList()
    );
  }

  Future<bool> willPop() async {

    if(_depth <= 0) {
      return true;
    }

    gotoParent();

    return false;
  }

  void gotoParent() {

    logging.info("Going to parent of $_currentDirectory, depth is $_depth");

    if(_depth <= 0) return;

    _depth--;

    if(_depth == 0 || _currentDirectory == null) {
      _currentDirectory = null;
      _depth = 0;
    } else {
      _currentDirectory = Path.dirname(_currentDirectory!);
    }

    buildFileCache();

    setState(() { });
  }

  void buildFileCache(){

    if(_currentDirectory == null) return;

    final dir = Directory(_currentDirectory!);

    try {
      _files = dir.listSync(recursive: false)
          .where((e) => e is Directory || widget.showFileFilter(e.path))
          .map((e) => SelectableDataItem(e, false, e is Directory))
          .toList();

      _files.sort((a, b) {

        if(a.isVisible  && !b.isVisible) {
          return -1;
        }

        if(b.isVisible && !a.isVisible) {
          return 1;
        }

        return compareNatural(Path.basename(a.item.path), Path.basename(b.item.path));
      });
    }
    catch(e) {
      logging.warning("Cannot access $_currentDirectory, $e");
      MessagePublisher.publishSomethingWentWrong("Cannot access $_currentDirectory!! No permissions.");
      gotoParent();
    }

  }

  void setDirectory(String path) {

    _currentDirectory = path;
    _depth++;

    buildFileCache();

    setState(() { });
  }
}