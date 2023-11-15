

import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/dbimpl/TableWatchDirectory.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WatchDirectoriesModel extends ChangeNotifier {

  List<String> directoryPaths = [];

  WatchDirectoriesModel(){
    update();
  }

  void update(){

    TableWatchDirectory.selectAll().then((value) {

      directoryPaths.clear();

      for(var element in value)  {
        directoryPaths.add(element.directoryPath);
      }

      notifyListeners();
    });
  }


  void addDirectory(String dir){
    if(directoryPaths.contains(dir)) {
      return;
    }

    TableWatchDirectory.insertDirectory(File(dir), 0, true)
        .then((value) {

      directoryPaths.add(dir);
      notifyListeners();
    });
  }

  void removeDirectory(String dir){

    TableWatchDirectory.removeDirectory(File(dir))
        .then((value) {

      if(directoryPaths.remove(dir)) {
        notifyListeners();
      }
    });
  }
}

class WatchDirectoriesPage extends  StatelessNavigationPage {
  const WatchDirectoriesPage({super.key}) : super(title: "Watch Directories", icon: Icons.folder);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WatchDirectoriesModel(),
      child: _WatchDirectoriesPage(this),
    );
  }
}

class _WatchDirectoriesPage extends StatefulWidget {
  final WatchDirectoriesPage parent;

  const _WatchDirectoriesPage(this.parent);

  @override
  State<_WatchDirectoriesPage> createState() => _WatchDirectoriesState();
}

class _WatchDirectoriesState extends State<_WatchDirectoriesPage> {

  Future<void> pickAddDirectory() async {

    var directoryModel = context.read<WatchDirectoriesModel>();

    var dir = await pickDirectory();

    if(dir != null) {
      directoryModel.addDirectory(dir);
    }
  }

  @override
  Widget build(BuildContext context) {

    var directoryModel = context.watch<WatchDirectoriesModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.parent.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: pickAddDirectory,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {

              if(directoryModel.directoryPaths.isNotEmpty) {

                directoryModel.removeDirectory(directoryModel.directoryPaths.first);
              }
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: directoryModel.directoryPaths.length,
        itemBuilder: (context, index) {
          var directory = directoryModel.directoryPaths[index];

          return InkWell(
              child:ListTile(
                title: Text(directory),
              )
          );
        },
      ),
    );
  }
}