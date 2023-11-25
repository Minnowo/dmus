import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:path/path.dart' as Path;
import '../Util.dart';
import '../localstorage/ImportController.dart';


final class CloudStorageDownloadHelper {

  CloudStorageDownloadHelper._();

  /// Downloads all songs from firebase based off the signed in user account
  static Future<void> downloadAllSongs(String userID) async {

    final bool a = await getExternalStoragePermission();

    if(!a) {
      logging.warning("No storage permission! Going to try anyway");
    }

    try {
      final String? downloadsPath = await getDownloadPath();

      if (downloadsPath == null) {
        logging.warning( 'External storage directory is null. Make sure external storage access is granted.');
        MessagePublisher.publishSomethingWentWrong("External storage folder is null!");
        return;
      }

      final downloadsDirectory = Directory(Path.join(downloadsPath, "dmus"));

      await downloadsDirectory.create();

      if(!await downloadsDirectory.exists()) {
        logging.warning( 'Cannot create downloads folder!! $downloadsDirectory');
        MessagePublisher.publishSomethingWentWrong("Cannot create downloads folder $downloadsDirectory");
        return;
      }

      logging.info("Downloads directory is $downloadsDirectory ==============================");

      MessagePublisher.publishSnackbar(const SnackBarData(text: "Downloading songs...", duration: Duration(seconds: 2)));

      final ref = FirebaseStorage.instance.ref('users/$userID/songs/');
      final ListResult result = await ref.list();

      final songsJsonFile = File('${downloadsDirectory.path}/songs.json');

      await ImportController.endImports();

      if (await songsJsonFile.exists()) {
        logging.info("Deleting existing songs json...");

        try {
          await songsJsonFile.delete();
        }
        on Exception catch(e) {
          logging.warning("Could not delete songs json! $e");
          MessagePublisher.publishSomethingWentWrong("Could not write to songs json metadata!");
          return;
        }
      }


      // Download the files
      for (final item in result.items) {

        if (item.name == 'songs.json') {

          final localFilePath = '${downloadsDirectory.path}/songs.json';

          await item.writeToFile(File(localFilePath));

          continue;
        }

        final localFile = File('${downloadsDirectory.path}/${item.name}');

        if (await localFile.exists()) {
          logging.info("Skipping download of $localFile since it already exists");
          await ImportController.importSong(localFile);
          continue;
        }

        logging.info("Downloading ${item.name}...");

        await item.writeToFile(localFile);
        await ImportController.importSong(localFile);
      }

      MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.allSongsDownloaded, duration: const Duration(seconds: 2)));

      logging.info("Finished downloading songs!");
    }
    on Exception catch (e) {
      logging.warning('Error downloading songs from Firebase Cloud Storage: $e');
      MessagePublisher.publishRawException(e);
    }
  }
}