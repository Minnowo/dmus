
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:logging/logging.dart';

import 'data/DataEntity.dart';


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
