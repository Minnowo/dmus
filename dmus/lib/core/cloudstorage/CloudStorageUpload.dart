import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../../ui/dialogs/form/songUploadForm.dart';
import '../../ui/lookfeel/Animations.dart';
import '../Util.dart';
import '../localstorage/dbimpl/TablePlaylist.dart';
import '../localstorage/dbimpl/TableSong.dart';


final class CloudStorageUploadHelper {

  CloudStorageUploadHelper._();



  /// Adds All songs to the Firebase Storage from the Local Storage
  /// Stored by the User that is currently Logged in
  static Future<void> addAllSongs(String userID,BuildContext context) async {

    final FirebaseStorage _storage = FirebaseStorage.instance;

    SongUploadFormResult? result = await animateOpenFromBottom<SongUploadFormResult?>(context, SongUploadForm());


    try {

      final allSongs = result?.songs;

      if(allSongs!.isEmpty) {
        MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.noSongsToUpload, duration: const Duration(seconds: 2)));
        return;
      }

      MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.uploadingSongs, duration: const Duration(seconds: 2)));


      final List<Map<String, dynamic>> allSongsDetails = [];

      /// create the upload tasks for each of the songs
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

        // Check if the song is already uploaded using the URI
        final isUploaded = await isSongUploaded(userID, file.uri);

        if (!isUploaded) {
          // Monitor the upload task as before
          uploadTask.snapshotEvents.listen((event) {
            final progress = event.bytesTransferred / event.totalBytes;
            logging.fine('Upload progress: $progress');
          }, onError: (error) {
            logging.fine('Error during upload: $error');
          });

          return uploadTask;
        } else {
          logging.finest('Song ${file.uri.pathSegments.last} is already uploaded.');
          return null; // Skip the upload task for already uploaded songs
        }
      }).toList();

      await Future.wait(uploadTasks.where((task) => task != null));

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

      MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.songsUploaded, duration: const Duration(seconds: 2)));

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

      MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.uploadingPlaylists, duration: const Duration(seconds: 2)));

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

      MessagePublisher.publishSnackbar(SnackBarData(text: LocalizationMapper.current.playlistsUploaded, duration: const Duration(seconds: 2)));

      logging.info('All playlists Firebase Cloud Storage.');

    }
    on Exception catch (e) {

      logging.warning('Error uploading playlists and songs to Firebase Cloud Storage: $e');

      MessagePublisher.publishRawException(e);
    }
  }

  static Future<bool> isSongUploaded(String userID, Uri? songUri) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      if (songUri == null) {
        // Handle the case where the songUri is null (invalid)
        return false;
      }

      // Construct the remote path for the song
      final remotePath = 'users/$userID/songs/${songUri.pathSegments.last}';

      // Get a reference to the song in Firebase Storage
      final reference = _storage.ref(remotePath);

      // Attempt to get metadata for the song
      final result = await reference.getMetadata();
      print(result);

      // If metadata is available, the song is uploaded
      return result != null;
    } catch (e) {
      // If an exception occurs or metadata is not available, consider it not uploaded
      return false;
    }
  }
}