
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import '../Util.dart';



/// The Image Cache Controller
///
/// Handles storing and fetching image data for songs
abstract class ImageCacheController {

  ImageCacheController._();

  /// The cache folder, which will exist inside the
  /// program document directory
  ///
  /// The folder contains a large number of hex-named
  /// folders to split up where cached files are put
  static const String imageCacheDir = "images";


  /// Converts the given SHA256 hash hex-string to a file location
  /// in the cache, which the contents should be saved
  static Future<File> hexToPath(String hex) async {

    Directory appDir = await getApplicationDocumentsDirectory();

    logging.finest("Getting cached path from $hex");

    return File(Path.join(appDir.path, imageCacheDir, "${hex[0]}${hex[1]}", hex));
  }


  /// Converts the given SHA256 hash to a file location
  /// in the cache, which the contents should be saved
  static Future<File> digestToPath(Digest d) async {
    return await hexToPath(bytesToHex(d.bytes));
  }


  /// Gets the path where a file would be stored from
  /// the cache-key encoded as hexadecimal
  ///
  /// If the file exists, it has been cached
  ///
  /// If the file does not exist, it has not been cached
  ///
  /// If the file is null, the given hex was not a valid cache key
  static Future<File?> getImagePath(String hex) async {

    if(hex.isEmpty || hex.length < 2) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await hexToPath(hex);
  }


  /// Gets the path where a file would be stored from
  /// the cache-key as raw bytes
  ///
  /// If the file exists, it has been cached
  ///
  /// If the file does not exist, it has not been cached
  ///
  /// If the file is null, the given hex was not a valid cache key
  static Future<File?> getImagePathFromRaw(Uint8List hex) async {

    if(hex.isEmpty || hex.length < 2) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await hexToPath(bytesToHex(hex));
  }


  /// Gets the path where a file would be stored from
  /// the cache-key as raw bytes
  ///
  /// If the file exists, it has been cached
  ///
  /// If the file does not exist, it has not been cached
  ///
  /// If the file is null, the given hex was not a valid cache key
  static Future<File?> getImagePathFromDigest(Digest d) async {

    if(d.bytes.isEmpty) {
      logging.warning("Cannot handle path with empty digest");
      return null;
    }

    return await digestToPath(d);
  }


  /// Takes the raw byte contents of an image
  /// and puts them into the image cache,
  ///
  /// Returns the cache-key of the given contents
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