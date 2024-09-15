


import 'package:dmus/core/data/UIEnumSettings.dart';
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
    _songPageTileTrailWith = songListWidgetTrailFromInt(getInt(_songPageTileTrailWithKey, 0));
    _currentlyPlayingSwipeMode = currentlyPlayingBarSwipeFromInt(getInt(_currentlyPlayingSwipeModeKey, 0));
    _queueFillMode = queueFillModeFromInt(getInt(_queueFillModeKey, 0));
    _playlistQueueFillMode = playlistQueueFillModeFromInt(getInt(_playlistQueueFillModeKey, 0));

    logging.config("Loaded setting $_darkThemeKey as $_isDarkTheme");
    logging.config("Loaded setting $_songPageTileTrailWithKey as $_songPageTileTrailWith");
    logging.config("Loaded setting $_currentlyPlayingSwipeModeKey as $_currentlyPlayingSwipeMode");
    logging.config("Loaded setting $_queueFillModeKey as $_queueFillMode");
    logging.config("Loaded setting $_playlistQueueFillModeKey as $_playlistQueueFillMode");
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

  static CurrentlyPlayingBarSwipe _currentlyPlayingSwipeMode = CurrentlyPlayingBarSwipe.swipeToCancel;
  static CurrentlyPlayingBarSwipe get currentlyPlayingSwipeMode => _currentlyPlayingSwipeMode;

  static void setCurrentlyPlayingSwipeMode(CurrentlyPlayingBarSwipe swipeMode) {
    logging.config("Setting $_currentlyPlayingSwipeModeKey to $swipeMode");
    _currentlyPlayingSwipeMode = swipeMode;
    TableSettings.persist(_currentlyPlayingSwipeModeKey, currentlyPlayingBarSwipeToInt(swipeMode).toString());
  }




  static const String _songPageTileTrailWithKey = "song_page_tile_trail";

  static SongListWidgetTrail _songPageTileTrailWith = SongListWidgetTrail.trailWithMenu;
  static SongListWidgetTrail get songPageTileTrailWith => _songPageTileTrailWith;

  static void setSongsPageTrailWith(SongListWidgetTrail trailWith) {
    logging.config("Setting $_songPageTileTrailWithKey to $trailWith");
    _songPageTileTrailWith = trailWith;
    TableSettings.persist(_songPageTileTrailWithKey, songListWidgetTrailToInt(trailWith).toString());
  }




  static const String _queueFillModeKey = "queue_fill_mode";

  static QueueFillMode _queueFillMode = QueueFillMode.fillWithRandom;
  static QueueFillMode get queueFillMode => _queueFillMode;

  static void setQueueFillMode(QueueFillMode trailWith) {
    logging.config("Setting $_queueFillModeKey to $trailWith");
    _queueFillMode = trailWith;
    TableSettings.persist(_queueFillModeKey, queueFillModeToInt(trailWith).toString());
  }



  static const String _playlistQueueFillModeKey = "playlist_queue_fill_mode";

  static PlaylistQueueFillMode _playlistQueueFillMode = PlaylistQueueFillMode.neverFill;
  static PlaylistQueueFillMode get playlistQueueFillMode => _playlistQueueFillMode;

  static void setPlaylistQueueFillMode(PlaylistQueueFillMode trailWith) {
    logging.config("Setting $_playlistQueueFillModeKey to $trailWith");
    _playlistQueueFillMode = trailWith;
    TableSettings.persist(_playlistQueueFillModeKey, playlistQueueFillModeToInt(trailWith).toString());
  }
}