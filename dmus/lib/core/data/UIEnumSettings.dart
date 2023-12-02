


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
