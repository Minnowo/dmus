


import 'package:dmus/core/localstorage/dbimpl/TableSettings.dart';

import '../Util.dart';

final class SettingsHandler {

  SettingsHandler._();

  static final Map<String, String?> settings = {};


  /// Loads the settings
  static Future<void> load() async {

    final f = await TableSettings.selectAll();

    settings.addAll(f);

    _isDarkTheme = getBool(_darkThemeKey, true);
    _currentlyPlayingSwipeMode = getInt(_currentlyPlayingSwipeModeKey, 0);
  }


  /// Saves all settings
  static Future<void> save() async {

    await TableSettings.save(settings);
  }


  /// Parses the setting as a bool
  static bool getBool(String key, bool default_) {

    final v = settings[key];

    if(v == null) {
      return default_;
    }

    return bool.tryParse(v) ?? default_;
  }

  /// Parses the setting as an int
  static int getInt(String key, int default_) {

    final v = settings[key];

    if(v == null) {
      return default_;
    }

    return int.tryParse(v) ?? default_;
  }



  static const String _darkThemeKey = "is_dark_theme";

  static bool _isDarkTheme = true;
  static bool get isDarkTheme => _isDarkTheme;

  static void setDarkTheme(bool isDarkTheme) {
    logging.config("Setting $_darkThemeKey to $isDarkTheme");
    _isDarkTheme = isDarkTheme;
    TableSettings.persist(_darkThemeKey, _isDarkTheme.toString());
  }




  static const String _currentlyPlayingSwipeModeKey = "currently_playing_swipe_mode";

  static int _currentlyPlayingSwipeMode = 0;
  static int get currentlyPlayingSwipeMode => _currentlyPlayingSwipeMode;

  static void setCurrentlyPlayingSwipeMode(int swipeMode) {
    logging.config("Setting $_currentlyPlayingSwipeModeKey to $swipeMode");
    _currentlyPlayingSwipeMode = swipeMode;
    TableSettings.persist(_currentlyPlayingSwipeModeKey, _currentlyPlayingSwipeModeKey.toString());
  }
}