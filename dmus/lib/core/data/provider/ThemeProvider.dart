import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  bool _isDarkModeEnabled = true;

  bool get isDarkModeEnabled => _isDarkModeEnabled;

  ThemeProvider() {

    _isDarkModeEnabled = SettingsHandler.isDarkTheme;
  }

  void toggleDarkMode() {
    setTheme(!_isDarkModeEnabled);
  }

  void setTheme(bool themeIsDarkMode){
    _isDarkModeEnabled = themeIsDarkMode;
    SettingsHandler.setDarkTheme(_isDarkModeEnabled);
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }
}