// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../Util.dart';
import '../localstorage/dbimpl/TablePlaylist.dart';
import '../localstorage/dbimpl/TableSong.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';


class UploadCloudStorageModel {


  // final FirebaseStorage _storage = FirebaseStorage.instance;

  // Adds All songs to the Firebase Storage from the Local Storage
  // Stored by the User that is currently Logged in
  Future<void> addAllSongs(String userID, BuildContext context) async {

    try {
      final allSongs = await TableSong.selectAllWithMetadata();
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Initialize an empty list to store song details
      final List<Map<String, dynamic>> allSongsDetails = [];

      // Display a Snackbar for upload start
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Uploading songs...'),
          duration: const Duration(seconds: 2),
        ),
      );

      final uploadTasks = allSongs.map((song) async {
        final file = song.file;
        final remotePath = 'users/$userID/songs/${file.uri.pathSegments.last}';
        final uploadTask = _storage.ref(remotePath).putFile(file);
        final hash = sha256.convert(await file.readAsBytes()).toString();

        // Create a JSON object for the song details
        final songDetails = {
        'name': song.metadata.trackName,
        'artist': song.metadata.albumArtistName,
        'hash': hash,
        };


        allSongsDetails.add(songDetails);

        // Monitor the upload task as before
        uploadTask.snapshotEvents.listen((event) {
        final progress = event.bytesTransferred / event.totalBytes;
        logging.finest('Upload progress: $progress');
        }, onError: (error) {
        logging.finest('Error during upload: $error');
        });

        return uploadTask;
      }).toList();


      await Future.wait(uploadTasks);

      // Create a JSON file with all the song details and upload it
      final allSongsDetailsJson = jsonEncode(allSongsDetails);
      final songsJsonRemotePath = 'users/$userID/songs/songs.json';
      final songsJsonUploadTask =
      _storage.ref(songsJsonRemotePath).putString(allSongsDetailsJson);


      songsJsonUploadTask.snapshotEvents.listen((event) {
        final progress = event.bytesTransferred / event.totalBytes;
        logging.finest('JSON file upload progress: $progress');
      }, onError: (error) {
        logging.finest('Error during JSON file upload: $error');
      });

      // Display a Snackbar for upload completion
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('All songs uploaded'),
          duration: const Duration(seconds: 2),
        ),
      );

      logging.finest('All songs and JSON file uploaded to Firebase Cloud Storage.');
    } catch (e) {
      logging.finest('Error uploading songs to Firebase Cloud Storage: $e');
    }
  }

  // Adds All Playlists to the Firebase Storage from the Local Storage
  // Stored by the User that is currently Logged in
  Future<void> addAllPlaylists(String userID, BuildContext context) async {
    try {
      final allPlaylists = await TablePlaylist.selectAll();
      final scaffoldMessenger = ScaffoldMessenger.of(context);


      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Uploading playlists...'),
          duration: const Duration(seconds: 2),
        ),
      );

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

      // Display a Snackbar for upload completion
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('All playlists uploaded'),
          duration: const Duration(seconds: 2),
        ),
      );

      logging.finest('All playlists Firebase Cloud Storage.');
    } catch (e) {
      logging.finest('Error uploading playlists and songs to Firebase Cloud Storage: $e');
    }
  }




}
