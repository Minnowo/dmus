
import 'package:audioplayers/audioplayers.dart';

class StaticAudioTest {

  static AudioPlayer player = AudioPlayer();

  static Future<void> playURL(String url) async {

    await player.setSourceUrl(url); // equivalent to setSource(UrlSource(url));
    await player.resume();
  }


  static Future<void> playerTestSong() async {

    const String url = "http://192.168.1.142:8000/test.mp3";

    await playURL(url);
  }



}