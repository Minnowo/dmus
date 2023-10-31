


import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;

import '../Util.dart';


class ImageCacheController {

  ImageCacheController._();

  static const String imageCacheDir = "images";

  static Future<File> hexToPath(String hex) async {

    Directory appDir = await getApplicationDocumentsDirectory();

    logging.info("Getting cached path from $hex");

    return File(Path.join(appDir.path, imageCacheDir, "${hex[0]}${hex[1]}", hex));
  }

  static Future<File> digestToPath(Digest d) async {
    return await hexToPath(bytesToHex(d.bytes));
  }


  static Future<File?> getImagePath(String hex) async {

    if(hex.isEmpty || hex.length < 2) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await hexToPath(hex);
  }

  static Future<File?> getImagePathFromRaw(Uint8List hex) async {

    if(hex.isEmpty || hex.length < 2) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await hexToPath(bytesToHex(hex));
  }

  static Future<File?> getImagePathFromDigest(Digest d) async {

    if(d.bytes.isEmpty) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await digestToPath(d);
  }

  static Future<Digest> cacheMemoryImage(Uint8List image) async {

    final Digest hash = sha256.convert(image);

    final File path = await digestToPath(hash);

    if(await path.exists()) {
      logging.info("Cache hit for key $hash");
      return hash;
    }

    await path.parent.create(recursive: true);

    logging.info("Caching image to $path with key $hash");

    await path.writeAsBytes(image);

    return hash;
  }


}