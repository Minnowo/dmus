


import 'package:dmus/core/localstorage/dbimpl/TableSettings.dart';

final class SettingsHandler {

  SettingsHandler._();

  static final Map<String, String?> settings = {};


  /// Loads the settings
  static Future<void> load() async {

    final f = await TableSettings.selectAll();

    settings.addAll(f);
  }


  /// Saves all settings
  static Future<void> save() async {

    await TableSettings.save(settings);
  }


  /// Parses the setting as a bool
  static bool? getBoolShouldEqual(String key, String shouldEqual) {

    final v = settings[key];

    if(v == null) {
      return null;
    }

    return v.compareTo(shouldEqual) == 0;
  }



  static const String _darkThemeKey = "is_dark_theme";

  static bool? get isDarkTheme => getBoolShouldEqual(_darkThemeKey, "${true}");

  static void setDarkTheme(bool isDarkTheme) {
    final String v = "$isDarkTheme";
    settings[_darkThemeKey] = v;
    TableSettings.persist(_darkThemeKey, v);
  }
}