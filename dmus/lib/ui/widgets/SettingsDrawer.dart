import 'package:dmus/ui/pages/WatchDirectoriesPage.dart';
import 'package:flutter/material.dart';

import '../dialogs/ImportDialog.dart';

class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    var headerColor = Theme.of(context).colorScheme.inversePrimary;
    var textColor =
        Theme.of(context).textTheme.headlineLarge?.color ?? Colors.white;

    var headerFontSize = 32.0;
    var subheaderFontSize = 24.0;

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
            onTap: () {},
          ),
          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text("Sync With Firebase",
                style:
                TextStyle(color: textColor, fontSize: subheaderFontSize)),
          ),

          // Additional list tiles for new settings
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Login'),
            onTap: () {
              // Handle security settings action
            },
          ),
          ListTile(
            leading: const Icon(Icons.create),
            title: const Text('Create Account'),
            onTap: () {
              // Handle language settings action
            },
          )
        ],
      ),
    );
  }
}
