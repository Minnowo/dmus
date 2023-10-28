
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
