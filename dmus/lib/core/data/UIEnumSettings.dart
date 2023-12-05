


enum SongListWidgetLead {
  leadWithArtwork,
  leadWithTrackNumber,
}

enum SongListWidgetTrail {
  trailWithMenu,
  trailWithDuration,
}

enum CurrentlyPlayingBarSwipe {
  swipeToCancel,
  swipeToNextPrevious,
}

enum QueueFillMode{
  fillWithRandom,
  fillWithRandomPrioritySameArtist,
  neverGenerate,
}



int songListWidgetTrailToInt(SongListWidgetTrail s) {
  return SongListWidgetTrail.values.indexOf(s);
}
SongListWidgetTrail songListWidgetTrailFromInt(int s) {
  return SongListWidgetTrail.values[s.clamp(0, SongListWidgetTrail.values.length - 1)];
}

int currentlyPlayingBarSwipeToInt(CurrentlyPlayingBarSwipe s) {
  return CurrentlyPlayingBarSwipe.values.indexOf(s);
}
CurrentlyPlayingBarSwipe currentlyPlayingBarSwipeFromInt(int s) {
  return CurrentlyPlayingBarSwipe.values[s.clamp(0, CurrentlyPlayingBarSwipe.values.length - 1)];
}

int queueFillModeToInt(QueueFillMode s) {
  return QueueFillMode.values.indexOf(s);
}
QueueFillMode queueFillModeFromInt(int s) {
  return QueueFillMode.values[s.clamp(0, QueueFillMode.values.length - 1)];
}
