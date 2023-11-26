

import 'dart:io';

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
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


class WatchDirectoriesPage extends StatefulWidget {

  const WatchDirectoriesPage({super.key});

  @override
  State<WatchDirectoriesPage> createState() => _WatchDirectoriesState();
}

class _WatchDirectoriesState extends State<WatchDirectoriesPage> {

  List<String> _directoryPaths = [];

  @override
  void initState() {
    super.initState();
    
    TableWatchDirectory.selectAll().then((value){
      
      _directoryPaths.clear();
      _directoryPaths.addAll(value.map((e) => e.directoryPath));

      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Watch Directories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: pickAddDirectory,
          ),
          const IconButton(
            icon: Icon(Icons.refresh),
            onPressed: ImportController.checkWatchFolders,
          ),
        ],
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[

            if(_directoryPaths.isEmpty)
              const Center(
                child: Text("Watch directories will be checked when the app starts and automatically import music.",
                    textAlign: TextAlign.center
                ),
              )

            else
              Expanded(
                  child: ListView (
                    children: [
                      for(final i in _directoryPaths)
                        InkWell(
                            child:ListTile(
                              title: Text(i),
                            )
                        ),
                    ],
                  )
              ),
          ]
      ),
    );
  }


  Future<void> pickAddDirectory() async {

    var dir = await pickDirectory();

    if(dir == null) return;

    TableWatchDirectory.insertDirectory(File(dir), 0, true)
        .then((value) {

      _directoryPaths.add(dir);

      setState(() { });
    });
  }
}