import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

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
      final downloadsDirectory = await getExternalStorageDirectory();

      if (downloadsDirectory == null) {
        logging.warning( 'External storage directory is null. Make sure external storage access is granted.');
        MessagePublisher.publishSomethingWentWrong("External storage folder is null!");
        return;
      }

      MessagePublisher.publishSnackbar(const SnackBarData(text: "Downloading songs...", duration: Duration(seconds: 2)));

      final ref = FirebaseStorage.instance.ref('users/$userID/songs/');
      final ListResult result = await ref.list();

      final songsJsonFile = File('${downloadsDirectory.path}/songs.json');

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
          continue;
        }

        logging.info("Downloading ${item.name}...");

        await item.writeToFile(localFile);
        await ImportController.importSong(localFile);
      }

      MessagePublisher.publishSnackbar(const SnackBarData(text: "All songs downloaded", duration: Duration(seconds: 2)));

      logging.info("Finished downloading songs!");
    }
    on Exception catch (e) {
      logging.warning('Error downloading songs from Firebase Cloud Storage: $e');
      MessagePublisher.publishRawException(e);
    }
  }
}