


enum SongListWidgetLead {
  leadWithArtwork,
  leadWithTrackNumber,
  leadWithDiskNumberTrackNumber,
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

enum PlaylistQueueFillMode{
  neverFill,
  fillWithRandom,
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

int playlistQueueFillModeToInt(PlaylistQueueFillMode s) {
  return PlaylistQueueFillMode.values.indexOf(s);
}
PlaylistQueueFillMode playlistQueueFillModeFromInt(int s) {
  return PlaylistQueueFillMode.values[s.clamp(0, PlaylistQueueFillMode.values.length - 1)];
}
