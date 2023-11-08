import 'dart:io';

import 'package:dmus/core/cloudstorage/DownloadCloudStorageModel.dart';
import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/pages/WatchDirectoriesPage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


import '../../core/Util.dart';
import '../dialogs/picker/ImportDialog.dart';
import '../../core/cloudstorage/UploadCloudStorageModel.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as Path;

import '../pages/cloud/SignIn.dart';
import '../pages/cloud/registerPage.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});


  Future<void> backupDatabase(BuildContext context) async {

    pickDirectory().then((value) async {

      if(value == null) return;

      File databaseExport = File(Path.join(value, DatabaseController.databaseFilename));

      logging.info(databaseExport);

      if(await databaseExport.exists()) {
        logging.warning("Cannot save file because it already exists");

        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBar("The path $databaseExport already exists"));
        }
        return;
      }

      if(await DatabaseController.backupDatabase(databaseExport)) {

        if(context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBar("Exported database to $databaseExport"));
        }

      }

    });

  }



  @override
  Widget build(BuildContext context) {
    var headerColor = Theme.of(context).colorScheme.inversePrimary;
    var textColor =
        Theme.of(context).textTheme.headlineLarge?.color ?? Colors.white;

    var headerFontSize = 32.0;
    var subheaderFontSize = 24.0;

    final User? user = FirebaseAuth.instance.currentUser;


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: headerColor,
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                color: textColor,
                fontSize: headerFontSize,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("General",
                style:
                TextStyle(color: textColor, fontSize: subheaderFontSize)),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Music"),
            onTap: () {
              Navigator.pop(context);
              showDialog(context: context, builder: (BuildContext context) => const ImportDialog());
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text("Watch Directories"),
            onTap: () async {
              Navigator.pop(context);
              await Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => const WatchDirectoriesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: const Text("Refresh Metadata"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text("Backup Database"),
            onTap: () => backupDatabase(context),
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Sync With Firebase",
                style:
                TextStyle(color: textColor, fontSize: subheaderFontSize)),
          ),


          // Login and Register is only shown the current user if is not logged in
          if (user == null)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => SignInWidget()));
                //popNavigatorSafe(context);
              },
            ),
          if (user == null)
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create Account'),
              onTap: () async {
                await Navigator.push(context, MaterialPageRoute( builder: (BuildContext context) => RegistrationWidget()));

                //popNavigatorSafe(context);
              },
            ),

          // FIREBASE settings if the User is logged in
          // Settings include: Upload Songs, Download Songs and Logut
          if (user != null)
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_upload),
                  title: const Text('Upload to Cloud Storage'),
                  onTap: () {
                    UploadCloudStorageModel().addAllSongs(user.uid, context);
                    UploadCloudStorageModel().addAllPlaylists(user.uid, context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: const Text('Download from Cloud'),
                  onTap: () {

                    DownloadCloudStorageModel().downloadAllSongs(user.uid,context);

                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    popNavigatorSafe(context);

                    if(context.mounted) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User logged out successfully'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
