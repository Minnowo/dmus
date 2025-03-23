import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/SelectionListPicker.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';
import '../../../generated/l10n.dart';

class FilePicker extends StatefulWidget {
  final bool Function(String) showFileFilter;

  const FilePicker({super.key, required this.showFileFilter});

  @override
  State<StatefulWidget> createState() => _FilePickerState();
}

class FileSystemEntityX {
  final FileSystemEntity systemEntity;
  final bool isDir;

  const FileSystemEntityX({required this.systemEntity, required this.isDir});
}

class _FilePickerState extends State<FilePicker> with SelectionListPicker<FileSystemEntityX> {
  static String? lastDirectory = null;
  static int lastDirectoryDepth = -1;

  final List<String> _externalStorageRoots = [];

  final TextEditingController _filterController = TextEditingController();

  int _depth = 0;
  bool _selctedAll = false;
  String? _currentDirectory;

  @override
  void initState() {
    super.initState();

    getExternalStoragePermission().whenComplete(() => setState(() => buildFileCache()));

    ExternalPath.getExternalStorageDirectories().then((value) {
      if (value != null) {
        for (final i in value) {
          _externalStorageRoots.add(i);
        }
      }

      if (_externalStorageRoots.isEmpty) {
        MessagePublisher.publishSomethingWentWrong(S.current.noStorage);
        popNavigatorSafe(context);
        return;
      }

      logging.info("last directory is $lastDirectory last dir depth is $lastDirectoryDepth");

      if (lastDirectory != null && Directory(lastDirectory!).existsSync()) {
        _currentDirectory = lastDirectory;
        _depth = lastDirectoryDepth;
        buildFileCache();
      } else if (_externalStorageRoots.length == 1) {
        _currentDirectory = _externalStorageRoots.first;
        _depth = 1;
        buildFileCache();
        lastDirectory = null;
        lastDirectoryDepth = -1;
      } else {
        lastDirectory = null;
        lastDirectoryDepth = -1;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.pickFiles),
          actions: [
            IconButton(onPressed: toggleSelectAll, icon: const Icon(Icons.select_all)),
            IconButton(onPressed: () => finishSelection(context), icon: const Icon(Icons.check)),
          ],
        ),
        body: Column(children: [
          Expanded(
            child: ListView(children: [
              if (_depth > 0)
                InkWell(
                    onTap: gotoParent,
                    child: const ListTile(
                      title: Text(".."),
                    )),
              if (_currentDirectory == null)
                for (final d in _externalStorageRoots)
                  InkWell(
                    child: ListTile(
                      title: Text(d),
                    ),
                    onTap: () => setDirectory(d),
                  ),
              if (_currentDirectory != null) ...buildFileList(),
            ]),
          ),
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(HORIZONTAL_PADDING),
              child: TextField(
                controller: _filterController,
                onChanged: filterDataEntities,
                decoration: InputDecoration(
                  hintText: S.current.filterFilename,
                  suffixIcon: IconButton(
                    onPressed: clearFilter,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            ),
          )
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24 + 16 * 2),
          child: FloatingActionButton(
            tooltip: S.current.confirmSelection,
            onPressed: () => finishSelection(context),
            child: const Icon(Icons.save),
          ),
        ),
      ),
    );
  }

  @override
  void clearFilter() {
    _filterController.text = "";
    super.clearFilter();
    setState(() {});
  }

  @override
  void finishSelection(BuildContext context) {
    lastDirectory = _currentDirectory;
    lastDirectoryDepth = _depth;

    popNavigatorSafeWithArgs<List<File>>(
        context, items.where((e) => e.isSelected).map((e) => File(e.item.systemEntity.path)).toList());
  }

  void toggleSelectAll() {
    _selctedAll = !_selctedAll;
    setAllItemsSelection(_selctedAll);
    setState(() {});
  }

  bool systemFileMatches(String search, FileSystemEntityX e) {
    return Path.basename(e.systemEntity.path).toLowerCase().contains(search);
  }

  void filterDataEntities(String text) {
    logging.info("asldkajlsdkajsldaksdjlksdjlaksjdlaksjdlak");
    super.filterItems(text, systemFileMatches);

    setState(() {});
  }

  List<Widget> buildFileList() {
    if (_currentDirectory == null) {
      return [];
    }

    final List<Widget> ritems = [];

    for (final i in items) {
      if (!i.isVisible) continue;

      if (!i.item.isDir) {
        ritems.add(InkWell(
          child: ListTile(
            title: Text(Path.basename(i.item.systemEntity.path)),
            selected: i.isSelected,
            selectedTileColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          onTap: () {
            i.isSelected = !i.isSelected;
            logging.info("Item is selected ${i.item}");
            setState(() {});
          },
        ));

        continue;
      }

      ritems.add(InkWell(
        child: ListTile(
          leading: const Icon(Icons.folder),
          title: Text(Path.basename(i.item.systemEntity.path)),
        ),
        onTap: () => setDirectory(i.item.systemEntity.path),
      ));
    }

    return ritems;
  }

  Future<bool> willPop() async {
    if (_depth <= 0) {
      return true;
    }

    gotoParent();

    return false;
  }

  void gotoParent() {
    logging.info("Going to parent of $_currentDirectory, depth is $_depth");

    if (_depth <= 0) return;

    _depth--;

    if (_depth == 0 || _currentDirectory == null) {
      _currentDirectory = null;
      _depth = 0;
    } else {
      _currentDirectory = Path.dirname(_currentDirectory!);
    }

    buildFileCache();

    setState(() {});
  }

  void buildFileCache() {
    if (_currentDirectory == null) return;

    final dir = Directory(_currentDirectory!);

    try {
      items.replaceRange(
          0,
          items.length,
          dir
              .listSync(recursive: false)
              .where((e) => e is Directory || widget.showFileFilter(e.path))
              .map((e) => SelectableDataItem(FileSystemEntityX(systemEntity: e, isDir: e is Directory), false, true)));

      items.sort((a, b) {
        if (a.item.isDir && !b.item.isDir) {
          return -1;
        }

        if (b.item.isDir && !a.item.isDir) {
          return 1;
        }

        return compareNatural(Path.basename(a.item.systemEntity.path), Path.basename(b.item.systemEntity.path));
      });
    } catch (e) {
      logging.warning("Cannot access $_currentDirectory, $e");
      MessagePublisher.publishSomethingWentWrong(
          "${S.current.cannotAccessDirectory1} $_currentDirectory${S.current.cannotAccessDirectory2}");
      gotoParent();
    }
  }

  void setDirectory(String path) {
    _currentDirectory = path;
    _depth++;

    buildFileCache();

    setState(() {});
  }
}
