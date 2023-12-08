import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/pages/AdvancedSettingsPage.dart';
import 'package:dmus/ui/pages/BlacklistedFilePage.dart';
import 'package:dmus/ui/pages/WatchDirectoriesPage.dart';
import 'package:flutter/material.dart';

import '../dialogs/picker/ImportDialog.dart';
import '../lookfeel/Animations.dart';
import '../lookfeel/CommonTheme.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    var subheaderFontSize = 24.0;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          const SizedBox(
            height: 128,
            child: DrawerHeader(
              child: Text(
                'dmus v1.0',
                style: TEXT_HEADER,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
            child: Text(LocalizationMapper.current.general,
                style:
                TextStyle(fontSize: subheaderFontSize)),
          ),

          ListTile(
            leading: const Icon(Icons.add),
            title: Text(LocalizationMapper.current.addMusic),
            onTap: () => showImportDialog(context),
          ),

          ListTile(
            leading: const Icon(Icons.folder),
            title: Text(LocalizationMapper.current.watchDirectories),
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
            child: Text(LocalizationMapper.current.other, style: TextStyle(fontSize: subheaderFontSize)),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(LocalizationMapper.current.advancedSettings),
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
}