// import 'package:flutter/material.dart';

// //Stateful widget to be added to the settings drawer to save the dark mode setting
// class ThemeToggle extends StatefulWidget {
//   final ValueChanged<bool> onToggle;
//   final bool isDarkModeEnabled;

//   const ThemeToggle({Key? key, required this.onToggle, required this.isDarkModeEnabled}) : super(key: key);

//   @override
//   _ThemeToggleState createState() => _ThemeToggleState();
// }

// class _ThemeToggleState extends State<ThemeToggle> {
//   @override
//   Widget build(BuildContext context) {
//     return SwitchListTile(
//       title: const Text('Dark Mode'),
//       value: widget.isDarkModeEnabled,
//       onChanged: (value) {
//         widget.onToggle(value);
//       },
//     );
//   }
// }


import 'package:dmus/ui/widgets/ThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Dark Mode'),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Switch(
              value: Provider.of<ThemeProvider>(context).isDarkModeEnabled,
              onChanged: (value) {
                Provider.of<ThemeProvider>(context, listen: false).toggleDarkMode();
              },
            ),
          ),
        ),
      ],
    );
  }
}
