
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:logging/logging.dart';


final logging = Logger('DMUS');

String formatTimeDisplay(Duration sp, Duration sd) {

  String hoursSP = "";
  String hoursSD = "";

  if(sd.inHours >= 1 ) {

    hoursSP = '${(sp.inHours % 60).toString().padLeft(2, '0')}:';
    hoursSD = '${(sd.inHours % 60).toString().padLeft(2, '0')}:';
  }

  return '$hoursSP'
      '${(sp.inMinutes % 60).toString().padLeft(2, '0')}'
      ':'
      '${(sp.inSeconds % 60).toString().padLeft(2, '0')}'
      ' / '
      '$hoursSD'
      '${(sd.inMinutes % 60).toString().padLeft(2, '0')}'
      ':'
      '${(sd.inSeconds % 60).toString().padLeft(2, '0')}'
  ;
}

String formatDuration(Duration d) {

  String hours = "";

  if(d.inHours >= 1 ) {

    hours = '${(d.inHours % 60).toString().padLeft(2, '0')}:';
  }
  return '$hours'
      '${(d.inMinutes % 60).toString().padLeft(2, '0')}'
      ':'
      '${(d.inSeconds % 60).toString().padLeft(2, '0')}'
  ;
}


String subtitleFromMetadata(Metadata m) {

  logging.finest("Getting subtitle from metadata: $m");

  List<String> a = [];

  if(m.albumName != null) {
    a.add(m.albumName!);
  }
  else if(m.albumArtistName != null) {
    a.add(m.albumArtistName!);
  }

  if(m.authorName != null) {
    a.add(m.authorName!);
  }
  else if(m.trackArtistNames != null) {
    a.add(m.trackArtistNames!.join(", "));
  }

  return a.join(" - ");
}

String currentlyPlayingTextFromMetadata(Metadata m) {
  logging.finest("Getting Artist(s) Name and Song Title from MetaData : $m");
  List<String> a = [];

  if(m.authorName != null) {
    a.add(m.authorName!);
  }
  else if(m.trackArtistNames != null) {
    a.add(m.trackArtistNames!.join(", "));
  }

  if (m.trackName != null)
    {
      a.add(m.trackName!);
    }


  return a.join(" --- ");

}