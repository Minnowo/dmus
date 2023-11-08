import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../Util.dart';
import '../localstorage/dbimpl/TablePlaylist.dart';
import '../localstorage/dbimpl/TableSong.dart';


final class CloudStorageUploadHelper {

  CloudStorageUploadHelper._();



  /// Adds All songs to the Firebase Storage from the Local Storage
  /// Stored by the User that is currently Logged in
  static Future<void> addAllSongs(String userID) async {

    final FirebaseStorage _storage = FirebaseStorage.instance;

    try {

      final allSongs = await TableSong.selectAllWithMetadata();

      if(allSongs.isEmpty) {
        MessagePublisher.publishSnackbar(const SnackBarData(text: "There are no songs to upload!", duration: Duration(seconds: 2)));
        return;
      }

      MessagePublisher.publishSnackbar(const SnackBarData(text: "Uploading songs...", duration: Duration(seconds: 2)));


      final List<Map<String, dynamic>> allSongsDetails = [];

      /// create the upload tasks for each of the sonsg
      final uploadTasks = allSongs.map((song) async {
        final file = song.file;
        final remotePath = 'users/$userID/songs/${file.uri.pathSegments.last}';
        final uploadTask = _storage.ref(remotePath).putFile(file);
        final hash = sha256.convert(await file.readAsBytes()).toString();

        final songDetails = {
          'name': song.metadata.trackName,
          'artist': song.metadata.albumArtistName,
          'hash': hash,
        };

        allSongsDetails.add(songDetails);

        // Monitor the upload task as before
        uploadTask.snapshotEvents.listen((event) {
          final progress = event.bytesTransferred / event.totalBytes;
          logging.fine('Upload progress: $progress');
        }, onError: (error) {
          logging.fine('Error during upload: $error');
        });

        return uploadTask;
      }).toList();


      await Future.wait(uploadTasks);

      // Create a JSON file with all the song details and upload it
      final allSongsDetailsJson = jsonEncode(allSongsDetails);
      final songsJsonRemotePath = 'users/$userID/songs/songs.json';
      final songsJsonUploadTask = _storage.ref(songsJsonRemotePath).putString(allSongsDetailsJson);

      songsJsonUploadTask.snapshotEvents.listen((event) {
        final progress = event.bytesTransferred / event.totalBytes;
        logging.finer('JSON file upload progress: $progress');
      }, onError: (error) {
        logging.finer('Error during JSON file upload: $error');
      });

      MessagePublisher.publishSnackbar(const SnackBarData(text: "All songs uploaded!", duration: Duration(seconds: 2)));

      logging.info('All songs and JSON file uploaded to Firebase Cloud Storage.');

    }
    on Exception catch (e) {

      logging.warning('Error uploading songs to Firebase Cloud Storage: $e');

      MessagePublisher.publishRawException(e);
    }
  }

  // Adds All Playlists to the Firebase Storage from the Local Storage
  // Stored by the User that is currently Logged in
  static Future<void> addAllPlaylists(String userID) async {

    final FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      final allPlaylists = await TablePlaylist.selectAll();

      MessagePublisher.publishSnackbar(const SnackBarData(text: "Uploading playlists!", duration: Duration(seconds: 2)));

      for (final playlist in allPlaylists) {
        // Create a folder for each playlist with the playlist's title
        final playlistFolder = 'users/$userID/playlists/${playlist.title}/';
        final songsInPlaylist = playlist.songs;

        // Iterate through the songs in the playlist
        for (final song in songsInPlaylist) {
          final file = song.file;
          final remotePath = '$playlistFolder${file.uri.pathSegments.last}';
          final uploadTask = _storage.ref(remotePath).putFile(file);

          // Monitor the upload task as before
          uploadTask.snapshotEvents.listen((event) {
            final progress = event.bytesTransferred / event.totalBytes;
            logging.finest('Upload progress: $progress');
          }, onError: (error) {
            logging.finest('Error during song upload: $error');
          });
        }
      }

      MessagePublisher.publishSnackbar(const SnackBarData(text: "All playlists uploaded!", duration: Duration(seconds: 2)));

      logging.info('All playlists Firebase Cloud Storage.');

    }
    on Exception catch (e) {

      logging.warning('Error uploading playlists and songs to Firebase Cloud Storage: $e');

      MessagePublisher.publishRawException(e);
    }
  }
}