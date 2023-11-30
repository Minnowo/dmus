import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkModeEnabled = false;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  void toggleDarkMode() {
    _isDarkModeEnabled = !_isDarkModeEnabled;
    notifyListeners();
  }

  void setTheme(bool themeIsDarkMode){
    _isDarkModeEnabled = themeIsDarkMode;
    notifyListeners();
  }
}