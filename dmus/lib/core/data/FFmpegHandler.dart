

import 'dart:io';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_session.dart';

import '../Util.dart';

final class FFmpegHandler {
  FFmpegHandler._();

  static Future<bool> encodeVideoAudioToFileAsMp3(File video, File audio, String title, String author, String desc, {File? thumb}) async {

    FFmpegSession session = await FFmpegKit.executeWithArguments([
      "-y",
      "-i",
      video.path,
      if(thumb != null)
        "-i",
      if(thumb != null)
        thumb.path,
      "-map",
      "0:a",
      if(thumb != null)
        "-map",
      if(thumb != null)
        "1:v",
      if(thumb != null)
        "-vcodec",
      if(thumb != null)
        "copy",
      "-acodec",
      "libmp3lame",
      '-metadata',
      'title=$title',
      '-metadata',
      'artist=$author',
      '-metadata',
      'description=$desc',
      audio.path
    ]);


    logging.info(await session.getAllLogsAsString());

    final returnCode = await session.getReturnCode();

    if(returnCode == null) {

      logging.info("Could not read return code");
      return false;
    }

    if (returnCode.isValueSuccess()) {
      logging.info("FFmpeg finished with success");
      return true;
    }

    if(returnCode.isValueError()) {
      logging.info("FFmpeg finished with failure");

      logging.warning(await session.getFailStackTrace());
      return false;
    }

    return false;
  }
}