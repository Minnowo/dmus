import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Util.dart';
import '../localstorage/dbimpl/TableSong.dart';

class CloudStorageModel {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addAllSongs(String userID, BuildContext context) async {
    try {
      final allSongs = await TableSong.selectAllWithMetadata();
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Display a Snackbar for upload start
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Uploading songs...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final uploadTasks = allSongs.map((song) {
        final file = song.file;
        final remotePath = 'users/$userID/songs/${file.uri.pathSegments.last}';
        final uploadTask = _storage.ref(remotePath).putFile(file);

        // Monitor the upload task as before
        uploadTask.snapshotEvents.listen((event) {
          final progress = event.bytesTransferred / event.totalBytes;
          logging.finest('Upload progress: $progress');
        }, onError: (error) {
          logging.finest('Error during upload: $error');
        });

        return uploadTask;
      }).toList();

      // Wait for all upload tasks to complete
      await Future.wait(uploadTasks);

      // Display a Snackbar for upload completion
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('All songs uploaded'),
          duration: const Duration(seconds: 2),
        ),
      );

      logging.finest('All songs uploaded to Firebase Cloud Storage.');
    } catch (e) {
      logging.finest('Error uploading songs to Firebase Cloud Storage: $e');
    }
  }
}
