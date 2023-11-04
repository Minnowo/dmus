
import 'dart:typed_data';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:logging/logging.dart';
import 'data/DataEntity.dart';


/// The global logger instance
final logging = Logger('DMUS');

const int maxInteger =  0x7FFFFFFFFFFFFFFF;
const int minInteger = -0x8000000000000000;

/// Formats the position time out of the duration time to display to the user
///
/// The format is HH:MM:SS / HH:MM:SS if duration exceeds 1 hour
///
/// The format is MM:SS / MM:SS if duration is less than 1 hour
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


/// Format a duration to display to the user
///
/// The format is HH:MM:SS / HH:MM:SS if duration exceeds 1 hour
///
/// The format is MM:SS / MM:SS if duration is less than 1 hour
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


/// Returns subtitles text for the given song metadata
///
/// The format is '{ALBUM_NAME | ALBUM_ARTIST_NAME} - {AUTHOR_NAME | TRACK_ARTIST_NAMES}'
///
/// If none of the information exists it returns an empty string
String subtitleFromMetadata(Metadata m) {

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


/// Gets the text to show when a song is being played
///
/// This information is from the songs metadata and the title,
/// in the format of '{AUTHOR_NAME | TRACK_ARTIST_NAMES} --- {TITLE}'
String currentlyPlayingTextFromMetadata(Song s) {

  var m = s.metadata;
  List<String> a = [];

  if(m.authorName != null) {
    a.add(m.authorName!);
  }
  else if(m.trackArtistNames != null) {
    a.add(m.trackArtistNames!.join(", "));
  }

  a.add(s.title);

  return a.join(" --- ");
}


/// Converts the given raw bytes to a hex string
String bytesToHex(List<int> bytes) {

  const hexDigits = '0123456789abcdef';
  var charCodes = Uint8List(bytes.length * 2);
  for (var i = 0, j = 0; i < bytes.length; i++) {
    var byte = bytes[i];
    charCodes[j++] = hexDigits.codeUnitAt((byte >> 4) & 0xF);
    charCodes[j++] = hexDigits.codeUnitAt(byte & 0xF);
  }
  return String.fromCharCodes(charCodes);
}
