import 'package:dmus/core/data/provider/ThemeProvider.dart';
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
            child: Consumer<ThemeProvider>(
                builder: (context, themProvider, child)  =>
                    Switch(
                      value: themProvider.isDarkModeEnabled,
                      onChanged: themProvider.setTheme,
                    )
            ),
          ),
        ),
      ],
    );
  }
}
