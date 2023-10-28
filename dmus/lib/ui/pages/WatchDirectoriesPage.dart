

import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WatchDirectoriesModel extends ChangeNotifier {

  List<String> directoryPaths = [];

  void addDirectory(String dir){
    if(directoryPaths.contains(dir)) {
      return;
    }

    directoryPaths.add(dir);
    notifyListeners();
  }

  void removeDirectory(String dir){
    if(directoryPaths.remove(dir)) {
      notifyListeners();
    }
  }
}

class WatchDirectoriesPage extends  NavigationPage {
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
  WatchDirectoriesPage parent;

  _WatchDirectoriesPage(this.parent);

  @override
  State<_WatchDirectoriesPage> createState() => _WatchDirectoriesState();
}

class _WatchDirectoriesState extends State<_WatchDirectoriesPage> {

  Future<void> pickAddDirectory() async {

    var directoryModel = context.read<WatchDirectoriesModel>();

    var dir = await pickDirectory();

    if(dir != null) {
      directoryModel.addDirectory(dir!);
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