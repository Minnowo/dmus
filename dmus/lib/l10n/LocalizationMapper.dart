//From: https://stackoverflow.com/questions/51803755/getting-buildcontext-in-flutter-for-localization

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:dmus/generated/intl/messages_all.dart';


import 'dart:async';
import 'dart:io';

class LocalizationMapper {

  LocalizationMapper._(Locale locale) : _localeName = locale.toString() {
    current = this;
  }

  final String _localeName;

  static late LocalizationMapper current;

  static Future<LocalizationMapper> load(Locale locale) async {
    await initializeMessages(locale.toString());
    final result = LocalizationMapper._(locale);
    return result;
  }

  static LocalizationMapper? of(BuildContext context) {
    return Localizations.of<LocalizationMapper>(context, LocalizationMapper);
  }

  ///------------------Localization getters------------------///

  //main.dart
  String get title {
    return Intl.message(
      'placeholder',
      name: 'title',
      desc: 'Title for the DMUS application',
      
    );
  }
  String get songImported {
    return Intl.message(
      'placeholder',
      name: 'songImported',
      desc: 'Song imported on Songs page',
      
    );
  }
  String get createdPlaylist {
    return Intl.message(
      'placeholder',
      name: 'createdPlaylist',
      desc: 'Playlist created',
      
    );
  }
  String get updatedPlaylist {
    return Intl.message(
      'placeholder',
      name: 'updatedPlaylist',
      desc: 'Playlist updated',
      
    );
  }
  String get error {
    return Intl.message(
      'placeholder',
      name: 'error',
      desc: 'Standard error message',
      
    );
  }

  //MetadataContextDialogue.dart
  String get editMetadata {
    return Intl.message(
      'placeholder',
      name: 'editMetadata',
      desc: 'Song metadata edited',
      
    );
  }
  String get lookupMetadata {
    return Intl.message(
      'placeholder',
      name: 'lookupMetadata',
      desc: 'Search song metadata',
      
    );
  }

  //PlaylistContextDialog.dart
  String get viewDetails {
    return Intl.message(
      'placeholder',
      name: 'viewDetails',
      desc: 'View song details in playlist',
      
    );
  }
  String get playNow {
    return Intl.message(
      'placeholder',
      name: 'playNow',
      desc: 'Play song',
      
    );
  }
  String get queueAll {
    return Intl.message(
      'placeholder',
      name: 'queueAll',
      desc: 'Queue all songs in playlist',
      
    );
  }
  String get editPlaylist {
    return Intl.message(
      'placeholder',
      name: 'editPlaylist',
      desc: 'Edit current playlist',
      
    );
  }
  String get close {
    return Intl.message(
      'placeholder',
      name: 'close',
      desc: 'Close playlist',
      
    );
  }

  //MetadataSearchForm.dart
  String get searchEmpty {
    return Intl.message(
      'placeholder',
      name: 'searchEmpty',
      desc: 'Returned when search attempted and no search text typed',
      
    );
  }
  String get searchError {
    return Intl.message(
      'placeholder',
      name: 'searchError',
      desc: 'Error performing metadata search',
      
    );
  }
  String get noSearchResults {
    return Intl.message(
      'placeholder',
      name: 'noSearchResults',
      desc: 'No search results were found',
      
    );
  }
  String get releases {
    return Intl.message(
      'placeholder',
      name: 'releases',
      desc: 'Releases results',
      
    );
  }
  String get recordings {
    return Intl.message(
      'placeholder',
      name: 'recordings',
      desc: 'Recordings results',
      
    );
  }
  String get search {
    return Intl.message(
      'placeholder',
      name: 'search',
      desc: 'Search button label',
      
    );
  }

  //SongContextDialogue.dart
  String get addToQueue {
    return Intl.message(
      'placeholder',
      name: 'addToQueue',
      
    );
  }

  //PlaylistCreationForm.dart
  String get playlistTitle {
    return Intl.message(
      'placeholder',
      name: 'playlistTitle',
      desc: 'Playlist title text entry label',
      
    );
  }
  String get emptyTitleError {
    return Intl.message(
      'placeholder',
      name: 'emptyTitleError',
      desc: 'Error returned when user does not enter a title when making a playlist',
      
    );
  }
  String get titleMaxLengthError {
    return Intl.message(
      'placeholder',
      name: 'titleMaxLengthError',
      desc: 'Error returned when user enters a playlist title longer than maximum character limit',
      
    );
  }
  String get selectedSongsIsEmpty {
    return Intl.message(
      'placeholder',
      name: 'selectedSongsIsEmpty',
      desc: 'Message displayed when user has not selected any songs to add to a playlist',
      
    );
  }
  String get increment {
    return Intl.message(
      'placeholder',
      name: 'increment',
      desc: 'Tooltip that displays the text increment',
      
    );
  }

  //ImportDialogue.dart
  String get addFiles {
    return Intl.message(
      'placeholder',
      name: 'addFiles',
      desc: 'Button labelled Add Files',
      
    );
  }
  String get addFolder {
    return Intl.message(
      'placeholder',
      name: 'addFolder',
      desc: 'Button labelled Add Folders',
      
    );
  }

  //SearchYesNoPicker.dart
  String get artist {
    return Intl.message(
      'placeholder',
      name: 'artist',
      
    );
  }
  String get tag {
    return Intl.message(
      'placeholder',
      name: 'tag',
      
    );
  }
  String get releaseTitle {
    return Intl.message(
      'placeholder',
      name: 'releaseTitle',
      
    );
  }
  String get searchResult {
    return Intl.message(
      'placeholder',
      name: 'searchResult',
      desc: 'Search Result label',
      
    );
  }
  String get property {
    return Intl.message(
      'placeholder',
      name: 'property',
      desc: 'Property label',
      
    );
  }
  String get value {
    return Intl.message(
      'placeholder',
      name: 'value',
      desc: 'Value label',
      
    );
  }
  String get use {
    return Intl.message(
      'placeholder',
      name: 'use',
      desc: 'Button labelled Use',
      
    );
  }
  String get cancel {
    return Intl.message(
      'placeholder',
      name: 'cancel',
      desc: 'Button labelled Cancel',
      
    );
  }

  //SongPicker.dart
  String get pickSongs {
    return Intl.message(
      'placeholder',
      name: 'pickSongs',
      desc: 'Pick Songs button',
      
    );
  }
  
  //SpeedModifierPicker.dart
  String get playbackSpeed {
    return Intl.message(
      'placeholder',
      name: 'playbackSpeed',
      desc: 'Playback Speed text form label',
      
    );
  }
  String get ok {
    return Intl.message(
      'placeholder',
      name: 'ok',
      desc: 'Ok button',
      
    );
  }
  
  //registerPage.dart
  String get enterValidEmail {
    return Intl.message(
      'placeholder',
      name: 'enterValidEmail',
      desc: 'Enter valid email label on registration or login page',
      
    );
  }
  String get minPasswordLen {
    return Intl.message(
      'placeholder',
      name: 'minPasswordLen',
      desc: 'Password must be at least given length',
      
    );
  }
  String get register {
    return Intl.message(
      'placeholder',
      name: 'register',
      desc: 'Register for new account button',
      
    );
  }

  //SignIn.dart
  String get signIn {
    return Intl.message(
      'placeholder',
      name: 'signIn',
      desc: 'Sign In button',
      
    );
  }
  String get email {
    return Intl.message(
      'placeholder',
      name: 'email',
      desc: 'Register for new account button',
      
    );
  }
  String get emailEmpty {
    return Intl.message(
      'placeholder',
      name: 'emailEmpty',
      desc: 'Error text for email field on register and login page',
      
    );
  }
  String get password {
    return Intl.message(
      'placeholder',
      name: 'password',
      desc: 'Register for new account button', 
    );
  }
  String get passwordEmpty {
    return Intl.message(
      'placeholder',
      name: 'passwordEmpty',
      desc: 'Error text for password field on register and login page',  
    );
  }

  //AlbumsPage.dart
  String get noAlbums {
    return Intl.message(
      'placeholder',
      name: 'noAlbums',
      desc: 'No albums available on the Albums page',
    );
  }

  //SongsPage.dart
  String get noSongs {
    return Intl.message(
      'placeholder',
      name: 'noSongs',
      desc: 'No songs available on the Songs page',
      
    );
  }

  String get blacklistPageTitle {
    return Intl.message(
      'placeholder',
      name: 'blacklistPageTitle',
      desc: 'Blacklisted Files',

    );
  }
  String get blacklistPageHelperText {
    return Intl.message(
      'placeholder',
      name: 'blacklistPageHelperText',
      desc: 'Files which are blocked from being imported will show up here. You can add or delete them using the buttons in the top.',

    );
  }


  String get allSongsDownloaded {
    return Intl.message(
      'placeholder',
      name: 'allSongsDownloaded',
      desc: 'All songs downloaded from firebase sync',
    );
  }
}