import 'dart:io';

// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

import '../Util.dart';
import '../localstorage/ImportController.dart';
import '../localstorage/dbimpl/TablePlaylist.dart';
import '../localstorage/dbimpl/TableSong.dart';

class DownloadCloudStorageModel {
  // final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> downloadAllSongs(String userID, BuildContext context) async {

    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.manageExternalStorage.request();
      logging.finest("Permission Denied");

      if (result.isPermanentlyDenied) {
        openAppSettings();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Storage permission is required. Please enable it in settings.'),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      } else if (!result.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Storage permission is required to download songs.'),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
    }


    try {
      final downloadsDirectory = await getExternalStorageDirectory();

      if (downloadsDirectory == null) {
        logging.finest(
            'External storage directory is null. Make sure external storage access is granted.');
        return;
      }

      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Downloading songs...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final ref = _storage.ref('users/$userID/songs/');
      final ListResult result = await ref.list();

      // Check if the songs.json file exists in local storage
      final songsJsonFile = File('${downloadsDirectory.path}/songs.json');
      if (songsJsonFile.existsSync()) {
        songsJsonFile.deleteSync(); // Delete the existing songs.json file
      }

      // Download and write the new songs.json file
      final songsJsonItem = result.items.firstWhere((item) =>
      item.name == 'songs.json');
      if (songsJsonItem != null) {
        final localFilePath = '${downloadsDirectory.path}/songs.json';
        await songsJsonItem.writeToFile(File(localFilePath));
      }

      // Downloading and adding other songs to the local database
      for (final item in result.items) {
        final songName = item.name;

        if (songName == 'songs.json') {
          continue; // Skip songs.json file (already processed above)
        }

        final localFilePath = '${downloadsDirectory.path}/$songName';

        // Check if the song already exists in local storage or the database
        final localFile = File(localFilePath);
        if (localFile.existsSync()) {
          logging.finest('Song $songName already exists, skipping download.');
          continue; // Skip the download for this song
        }

        await item.writeToFile(localFile);
        await ImportController.importSong(localFile);

        logging.finest(localFile);
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('All songs downloaded'),
          duration: const Duration(seconds: 2),
        ),
      );

      logging.finest('All songs downloaded to the external storage directory.');
    } catch (e) {
      logging.finest('Error downloading songs from Firebase Cloud Storage: $e');
    }

  }
}
