import 'dart:io';

import 'package:dmus/core/cloudstorage/CloudStorageDownload.dart';
import 'package:dmus/core/data/FileDialog.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/ConfirmDestructiveAction.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/pages/AdvancedSettingsPage.dart';
import 'package:dmus/ui/pages/BlacklistedFilePage.dart';
import 'package:dmus/ui/pages/WatchDirectoriesPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

import '../../core/Util.dart';
import '../../core/cloudstorage/CloudStorageUpload.dart';
import '../dialogs/picker/ImportDialog.dart';
import '../lookfeel/Animations.dart';
import '../pages/cloud/SignIn.dart';
import '../pages/cloud/registerPage.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    var headerFontSize = 32.0;
    var subheaderFontSize = 24.0;

    final User? user = FirebaseAuth.instance.currentUser;


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          const SizedBox(
            height: 128,
            child: DrawerHeader(
              child: Text(
                'dmus v0.1',
                style: TEXT_HEADER,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: Text("General",
                style:
                TextStyle(fontSize: subheaderFontSize)),
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Add Music"),
            onTap: () => showImportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text("Watch Directories"),
            onTap: () => manageWatchDirectories(context),
          ),

          ListTile(
            leading: const Icon(Icons.block),
            title: Text(LocalizationMapper.current.blacklistPageTitle),
            onTap: () => showBlacklistedFiles(context),
          ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: Text("Sync With Firebase",
                style:
                TextStyle(fontSize: subheaderFontSize)),
          ),

          if (user == null)
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('Login'),
              onTap: () => showSignInPage(context),
            ),

          if (user == null)
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Create Account'),
              onTap: () => showRegistrationPage(context),
            ),

          if (user != null)
            Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.cloud_upload),
                  title: const Text('Upload to Cloud Storage'),
                  onTap: () => handleSongUpload(context),
                ),

                ListTile(
                  leading: const Icon(Icons.cloud_download),
                  title: const Text('Download from Cloud'),
                  onTap: () => handleSongDownload(context),
                ),

                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log Out'),
                  onTap: () => handleLogout(context),
                ),

              ],
            ),

          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: Text("Other", style: TextStyle(fontSize: subheaderFontSize)),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Advanced Settings"),
            onTap: () => showAdvancedSettings(context),
          ),
        ],
      ),
    );
  }


  Future<void> showAdvancedSettings(BuildContext context) async {

    popNavigatorSafe(context);
    await animateOpenFromBottom(context, const AdvancedSettingsPage());
  }
  Future<void> showBlacklistedFiles(BuildContext context) async {

    popNavigatorSafe(context);
    await animateOpenFromBottom(context, const BlacklistedFilePage());
  }

  Future<void> showImportDialog(BuildContext context) async {

    popNavigatorSafe(context);
    await showDialog(context: context, builder: (BuildContext context) => const ImportDialog());
  }

  Future<void> manageWatchDirectories(BuildContext context) async {

    popNavigatorSafe(context);
    await animateOpenFromBottom(context, const WatchDirectoriesPage());
  }

  Future<void> showRegistrationPage(BuildContext context) async {

    popNavigatorSafe(context);
    await animateOpenFromBottom(context, RegistrationWidget());
  }

  Future<void> showSignInPage(BuildContext context) async {

    popNavigatorSafe(context);
    await animateOpenFromBottom(context, const SignInWidget());
  }


  Future<void> handleSongDownload(BuildContext context) async {

    popNavigatorSafe(context);

    final User? user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      await CloudStorageDownloadHelper.downloadAllSongs(user.uid);
    }
  }
  Future<void> handleSongUpload(BuildContext context) async {

    popNavigatorSafe(context);

    final User? user = FirebaseAuth.instance.currentUser;

    if(user != null) {
      await CloudStorageUploadHelper.addAllSongs(user.uid);
      //await CloudStorageUploadHelper.addAllPlaylists(user.uid);
    }
  }

  Future<void> handleLogout(BuildContext context) async {

    popNavigatorSafe(context);

    await FirebaseAuth.instance.signOut();

    if(context.mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User logged out successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

}