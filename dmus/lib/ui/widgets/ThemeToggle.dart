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
