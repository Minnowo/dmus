import 'package:flutter/material.dart';

class SettingsDrawer extends StatelessWidget {
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
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("General",
                style:
                TextStyle(color: textColor, fontSize: subheaderFontSize)),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: const Text("Add Music"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.folder),
            title: Text("Watch Directories"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.refresh),
            title: Text("Refresh Metadata"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text("Backup Database"),
            onTap: () {},
          ),
          Divider(),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text("Sync With Firebase",
                style:
                    TextStyle(color: textColor, fontSize: subheaderFontSize)),
          ),

          // Additional list tiles for new settings
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'),
            onTap: () {
              // Handle security settings action
            },
          ),
          ListTile(
            leading: Icon(Icons.create),
            title: Text('Create Account'),
            onTap: () {
              // Handle language settings action
            },
          )
        ],
      ),
    );
  }
}
