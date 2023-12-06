
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as Path;
import '../Util.dart';



/// The Image Cache Controller
///
/// Handles storing and fetching image data for songs
abstract class ImageCacheController {

  ImageCacheController._();

  static Map<String, Pair<Digest?, bool>> _dirCoverCache = {};

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



  /// Takes the raw byte contents of an image
  /// and puts them into the image cache,
  ///
  /// Returns the cache-key of the given contents
  static Future<Digest?> cacheFileImage(File image) async {

    if(!await image.exists()) {
      return null;
    }

    final Digest hash = await sha256.bind(image.openRead()).first;

    final File path = await digestToPath(hash);

    if(await path.exists()) {
      return hash;
    }

    await path.parent.create(recursive: true);

    await image.copy(path.path);

    return hash;
  }


  /// Copies a file into a temp directory with the given extension
  static Future<File?> copyToTempWithExtension(File path, String tempNameExtension) async {

    try {

      Directory cache = await getTemporaryDirectory();

      File tempFile = File(Path.join(cache.path, "${Path.basename(path.path)}.$tempNameExtension"));

      await path.copy(tempFile.path);

      return tempFile;
    }
    on MissingPlatformDirectoryException catch(e){
      logging.warning("Could not get temp directory!; $e");
      MessagePublisher.publishSomethingWentWrong(LocalizationMapper.current.noTemporaryDirectory);
    }
    on IOException catch(e) {
      logging.warning("Could not copy file to temp; $e");
      MessagePublisher.publishRawException(e);
    }
    on Exception catch(e) {
      MessagePublisher.publishRawException(e);
    }

    return null;
  }


  /// Searches the given directory for common album cover filenames and caches them
  ///
  /// Returns the cache key if it finds something, otherwise null
  static Future<Digest?> findAndCacheCoverFromDirectory(Directory dir) async {

    Pair<Digest?, bool>? p = _dirCoverCache[dir.path];

    if(p != null) {

      logging.info("Cache hit with directory cover art!!!");

      if(p.itemB) {
        return p.itemA;
      }

      return null;
    }

    bool a = await getExternalStoragePermission();

    if(!a) {
      logging.warning("Cannot import from folder $dir because there is no permission, trying anyway!!!");
    }

    try {

      var files = await dir.list(recursive: false)
          .where((event) => imageFileExtensions.contains(fileExtensionNoDot(event.path).toLowerCase()))
          .where((event) => albumArtFilenames.contains(Path.basenameWithoutExtension(event.path).toLowerCase()))
          .map((event) => File(event.path))
          .toList();

      logging.info("found files $files");

      if(files.isEmpty) {
        _dirCoverCache.putIfAbsent(dir.path, () => Pair(itemA: null, itemB: false));
        return null;
      }

      File f = files.first;

      Digest? d = await cacheFileImage(f);

      if(d == null) {
        return null;
      }

      Pair<Digest?, bool> p = Pair(itemA: d, itemB: true);

      _dirCoverCache.putIfAbsent(dir.path, () => p);

      return d;
    }
    on PathAccessException catch(e) {

      logging.warning("There is actually no permissions to read this path! $e");
    }
    on Exception catch(e) {

      logging.warning("Error while reading files from directory! $e");
    }

    return null;
  }
}