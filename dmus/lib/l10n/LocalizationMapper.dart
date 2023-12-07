//From: https://stackoverflow.com/questions/51803755/getting-buildcontext-in-flutter-for-localization

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
  String get errorShort {
    return Intl.message(
      'placeholder',
      name: 'errorShort',
      desc: 'Standard short error message', 
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

  //DataEntityPicker.dart
  String get confirmSelection {
    return Intl.message(
      'placeholder',
      name: 'confirmSelection',      
    );
  }
  String get filterSongs {
    return Intl.message(
      'placeholder',
      name: 'filterSongs',      
    );
  }
  String get filterPlaylists {
    return Intl.message(
      'placeholder',
      name: 'filterPlaylists',      
    );
  }
  String get pickPlaylists {
    return Intl.message(
      'placeholder',
      name: 'pickPlaylists',      
    );
  }

  //FilePicker.dart
  String get pickFiles {
    return Intl.message(
      'placeholder',
      name: 'pickFiles',      
    );
  }
  String get filterFilename {
    return Intl.message(
      'placeholder',
      name: 'filterFilename',      
    );
  }
  String get cannotAccessDirectory1 {
    return Intl.message(
      'placeholder',
      name: 'cannotAccessDirectory1',      
    );
  }
  String get cannotAccessDirectory2 {
    return Intl.message(
      'placeholder',
      name: 'cannotAccessDirectory2',      
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
  String get trackArtistNames {
    return Intl.message(
      'placeholder',
      name: 'trackArtistNames',
    );
  }
  String get trackName {
  return Intl.message(
    'placeholder',
    name: 'trackName',
  );
}

String get albumName {
  return Intl.message(
    'placeholder',
    name: 'albumName',
  );
}

String get albumArtistName {
  return Intl.message(
    'placeholder',
    name: 'albumArtistName',
  );
}

String get trackDuration {
  return Intl.message(
    'placeholder',
    name: 'trackDuration',
  );
}

String get bitrate {
  return Intl.message(
    'placeholder',
    name: 'bitrate',
  );
}

String get mimeType {
  return Intl.message(
    'placeholder',
    name: 'mimeType',
  );
}

String get year {
  return Intl.message(
    'placeholder',
    name: 'year',
  );
}

String get genre {
  return Intl.message(
    'placeholder',
    name: 'genre',
  );
}

String get trackNumber {
  return Intl.message(
    'placeholder',
    name: 'trackNumber',
  );
}

String get diskNumber {
  return Intl.message(
    'placeholder',
    name: 'diskNumber',
  );
}

String get authorName {
  return Intl.message(
    'placeholder',
    name: 'authorName',
  );
}

String get writerName {
  return Intl.message(
    'placeholder',
    name: 'writerName',
  );
}

  //PlayListsPage.dart
  String get playlists {
    return Intl.message(
      'placeholder',
      name: 'playlists',
    );
  }

  //SelectedPlaylistPage.dart
  String get playlist {
    return Intl.message(
      'placeholder',
      name: 'playlist',
    );
  }
  String get playlistEmpty {
    return Intl.message(
      'placeholder',
      name: 'playlistEmpty',
    );
  }

  String get sortByID {
    return Intl.message(
      'placeholder',
      name: 'sortByID',
    );
  }

  String get sortByTitle {
    return Intl.message(
      'placeholder',
      name: 'sortByTitle',
    );
  }

  String get sortByDuration {
    return Intl.message(
      'placeholder',
      name: 'sortByDuration',
    );
  }

  String get sortByNumberOfTracks {
    return Intl.message(
      'placeholder',
      name: 'sortByNumberOfTracks',
    );
  }
  String get sortByRandom {
    return Intl.message(
      'placeholder',
      name: 'sortByRandom',
    );
  }


  String get noPlaylists {
    return Intl.message(
      'placeholder',
      name: 'noPlaylists',
    );
  }

  String get clickToCreate {
    return Intl.message(
      'placeholder',
      name: 'clickToCreate',
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
  String get firstReleaseDate {
    return Intl.message(
      'placeholder',
      name: 'firstReleaseDate',      
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
  String get savePlaylist {
    return Intl.message(
      'placeholder',
      name: 'savePlaylist',      
    );
  }

  //songUploadForm.dart
    String get uploadSongs {
    return Intl.message(
      'placeholder',
      name: 'uploadSongs',      
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

  //Util.dart
  String get metadataRefreshConfirm {
    return Intl.message(
      'placeholder',
      name: 'metadataRefreshConfirm',      
    );
  }
  String get pathAlreadyExists1 {
    return Intl.message(
      'placeholder',
      name: 'pathAlreadyExists1',      
    );
  }
  String get pathAlreadyExists2 {
    return Intl.message(
      'placeholder',
      name: 'pathAlreadyExists2',      
    );
  }
  String get exportedDatabase {
    return Intl.message(
      'placeholder',
      name: 'exportedDatabase',      
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
      
    );
  }
  String get blacklistPageHelperText {
    return Intl.message(
      'placeholder',
      name: 'blacklistPageHelperText',
      desc: 'Files which are blocked from being imported will show up here. You can add or delete them using the buttons in the top.',
    );
  }


  String get shareButton {
    return Intl.message(
      'placeholder',
      name: 'shareButton',
      desc: 'Share stuff',
    );
  }

  String get allSongsDownloaded {
    return Intl.message(
      'placeholder',
      name: 'allSongsDownloaded',
      desc: 'All songs downloaded from firebase sync',
    );
  }

//CORE
  String get cannotPlaySongFile1 {
    return Intl.message(
      'placeholder',
      name: 'cannotPlaySongFile1',  
    );
  }
  String get cannotPlaySongFile2 {
    return Intl.message(
      'placeholder',
      name: 'cannotPlaySongFile2',  
    );
  }

  String get cannotPlayAudio {
    return Intl.message(
      'placeholder',
      name: 'cannotPlayAudio',  
    );
  }

  String get externalFolderNull {
    return Intl.message(
      'placeholder',
      name: 'externalFolderNull',
    );
  }
  String get cannotCreateDownloadsFolder {
    return Intl.message(
      'placeholder',
      name: 'cannotCreateDownloadsFolder',
    );
  }
  String get downloadingSongs {
    return Intl.message(
      'placeholder',
      name: 'downloadingSongs',
    );
  }
  String get couldNotWriteSongs {
    return Intl.message(
      'placeholder',
      name: 'couldNotWriteSongs',  
    );
  }
	
  String get noSongsToUpload {
    return Intl.message(
      'placeholder',
      name: 'noSongsToUpload',
    );
  }
  String get uploadingSongs {
    return Intl.message(
      'placeholder',
      name: 'uploadingSongs',
    );
  }
  String get songsUploaded {
    return Intl.message(
      'placeholder',
      name: 'songsUploaded',
    );
  }
  String get uploadingPlaylists {
    return Intl.message(
      'placeholder',
      name: 'uploadingPlaylists',  
    );
  }
  String get playlistsUploaded {
    return Intl.message(
      'placeholder',
      name: 'playlistsUploaded',
    );
  }
 
  String get noTemporaryDirectory {
    return Intl.message(
      'placeholder',
      name: 'noTemporaryDirectory',
    );
  }

  String get checkingDirectories1 {
    return Intl.message(
      'placeholder',
      name: 'checkingDirectories1',  
    );
  }
  String get checkingDirectories2 {
    return Intl.message(
      'placeholder',
      name: 'checkingDirectories2',  
    );
  }
  String get songPathDoesNotExist1 {
    return Intl.message(
      'placeholder',
      name: 'songPathDoesNotExist1',  
    );
  }
  String get songPathDoesNotExist2 {
    return Intl.message(
      'placeholder',
      name: 'songPathDoesNotExist2',  
    );
  }
  String get cannotImportSongDoesNotExist {
    return Intl.message(
      'placeholder',
      name: 'cannotImportSongDoesNotExist',  
    );
  }
  String get dbError {
    return Intl.message(
      'placeholder',
      name: 'dbError',  
    );
  }
  String get cannotImportSongJustImported {
    return Intl.message(
      'placeholder',
      name: 'cannotImportSongJustImported',  
    );
  }  
  String get importingSongs1 {
    return Intl.message(
      'placeholder',
      name: 'importingSongs1',
    );
  }
  String get importingSongs2 {
    return Intl.message(
      'placeholder',
      name: 'importingSongs2',
    );
  }  
  String get noFilesInFolder {
    return Intl.message(
      'placeholder',
      name: 'noFilesInFolder',  
    );
  }  
  String get noPermissionInDirectory {
    return Intl.message(
      'placeholder',
      name: 'noPermissionInDirectory',  
    );
  }  
  String get emptyName {
    return Intl.message(
      'placeholder',
      name: 'emptyName',  
    );
  }  
  String get cannotEditPlaylist {
    return Intl.message(
      'placeholder',
      name: 'cannotEditPlaylist',  
    );
  }
	
  String get deletePlaylist {
    return Intl.message(
      'placeholder',
      name: 'deletePlaylist',  
    );
  }  
  String get confirmPlaylistDelete {
    return Intl.message(
      'placeholder',
      name: 'confirmPlaylistDelete',
    );
  }  
  String get playlistRemoved1 {
    return Intl.message(
      'placeholder',
      name: 'playlistRemoved1',  
    );
  }	
  String get playlistRemoved2 {
    return Intl.message(
      'placeholder',
      name: 'playlistRemoved2',  
    );
  }	

  String get shareFile {
    return Intl.message(
      'placeholder',
      name: 'shareFile',  
    );
  }  
  String get shareTitle {
    return Intl.message(
      'placeholder',
      name: 'shareTitle',  
    );
  }  
  String get shareTitlePlus {
    return Intl.message(
      'placeholder',
      name: 'shareTitlePlus',  
    );
  }  
  String get shareAllMore {
    return Intl.message(
      'placeholder',
      name: 'shareAllMore',  
    );
  }  
  String get sharePicture {
    return Intl.message(
      'placeholder',
      name: 'sharePicture',  
    );
  }

  String get removeQueue {
    return Intl.message(
      'placeholder',
      name: 'removeQueue',  
    );
  }  
  String get shareAllSongs {
    return Intl.message(
      'placeholder',
      name: 'shareAllSongs',  
    );
  }

  String get removeSong {
    return Intl.message(
      'placeholder',
      name: 'removeSong',  
    );
  }  
  String get removeAndBlock {
    return Intl.message(
      'placeholder',
      name: 'removeAndBlock',  
    );
  }  
  String get titleAddedToQueue {
    return Intl.message(
      'placeholder',
      name: 'titleAddedToQueue',  
    );
  }  
  String get confirmBlockSong {
    return Intl.message(
      'placeholder',
      name: 'confirmBlockSong',  
    );
  }  
  String get block {
    return Intl.message(
      'placeholder',
      name: 'block',
    );
  }  
  String get keep {
    return Intl.message(
      'placeholder',
      name: 'keep',  
    );
  }  
  String get confirmRemoveSong {
    return Intl.message(
      'placeholder',
      name: 'confirmRemoveSong',  
    );
  }  
  String get remove {
    return Intl.message(
      'placeholder',
      name: 'remove',  
    );
  }  
  String get songRemoved1 {
    return Intl.message(
      'placeholder',
      name: 'songRemoved1',  
    );
  }
    String get songRemoved2 {
    return Intl.message(
      'placeholder',
      name: 'songRemoved2',  
    );
  }

  String get metadataLookup {
    return Intl.message(
      'placeholder',
      name: 'metadataLookup',  
    );
  }  
  String get nA {
    return Intl.message(
      'placeholder',
      name: 'nA',  
    );
  }  

  String get createPlaylist {
    return Intl.message(
      'placeholder',
      name: 'createPlaylist',  
    );
  }  
  String get gotSongs {
    return Intl.message(
      'placeholder',
      name: 'gotSongs',  
    );
  }

  String get noStorage {
    return Intl.message(
      'placeholder',
      name: 'noStorage',  
    );
  }  
  String get pickFile {
    return Intl.message(
      'placeholder',
      name: 'pickFile',  
    );
  }  

  String get releaseGroup {
    return Intl.message(
      'placeholder',
      name: 'releaseGroup',  
    );
  }  
  String get releaseDate {
    return Intl.message(
      'placeholder',
      name: 'releaseDate',  
    );
  }  
  String get trackCount {
    return Intl.message(
      'placeholder',
      name: 'trackCount',  
    );
  }
  String get releaseCountry {
    return Intl.message(
      'placeholder',
      name: 'releaseCountry',  
    );
  }  
  String get releaseStatus {
    return Intl.message(
      'placeholder',
      name: 'releaseStatus',  
    );
  }  
  String get iD {
    return Intl.message(
      'placeholder',
      name: 'iD',  
    );
  }
  String get statusID {
    return Intl.message(
      'placeholder',
      name: 'statusID',  
    );
  }  
  String get packagingID {
    return Intl.message(
      'placeholder',
      name: 'packagingID',  
    );
  }
  String get length {
    return Intl.message(
      'placeholder',
      name: 'length',  
    );
  }

  String get filterName {
    return Intl.message(
      'placeholder',
      name: 'filterName',
    );
  }  
	  
  String get passwordLength {
    return Intl.message(
      'placeholder',
      name: 'passwordLength',  
    );
  }  
  String get registrationSuccessful {
    return Intl.message(
      'placeholder',
      name: 'registrationSuccessful',  
    );
  }
  String get registrationFailed {
    return Intl.message(
      'placeholder',
      name: 'registrationFailed',
    );
  }  
  String get registration {
    return Intl.message(
      'placeholder',
      name: 'registration',
    );
  }
  String get signedIn {
    return Intl.message(
      'placeholder',
      name: 'signedIn',
    );
  }

  String get incorrectPassword {
    return Intl.message(
      'placeholder',
      name: 'incorrectPassword',  
    );
  }  
  String get emailNotFound {
    return Intl.message(
      'placeholder',
      name: 'emailNotFound',  
    );
  }  
  String get signInError {
    return Intl.message(
      'placeholder',
      name: 'signInError',  
    );
  }
  String get wrongPassword {
    return Intl.message(
      'placeholder',
      name: 'wrongPassword',
    );
  }  
  String get userNotFound {
    return Intl.message(
      'placeholder',
      name: 'userNotFound',
    );
  }

  //AdvancedSettingsPage.dart
  String get advancedSettings {
    return Intl.message(
      'placeholder',
      name: 'advancedSettings',
    );
  }
  String get songsPageLITrail {
    return Intl.message(
      'placeholder',
      name: 'songsPageLITrail',
    );
  }
  String get trailMenu {
    return Intl.message(
      'placeholder',
      name: 'trailMenu',
    );
  }
  String get trailDuration {
    return Intl.message(
      'placeholder',
      name: 'trailDuration',
    );
  }
  String get random {
    return Intl.message(
      'placeholder',
      name: 'random',
    );
  }
  String get playBarSwipeMode {
    return Intl.message(
      'placeholder',
      name: 'playBarSwipeMode',
    );
  }
  String get swipeStop {
    return Intl.message(
      'placeholder',
      name: 'swipeStop',
    );
  }
  String get swipeNext {
    return Intl.message(
      'placeholder',
      name: 'swipeNext',
    );
  }
  String get queueMode {
    return Intl.message(
      'placeholder',
      name: 'queueMode',
    );
  }
  String get fillRandom {
    return Intl.message(
      'placeholder',
      name: 'fillRandom',
    );
  }
  String get fillRandomArtistPriority {
    return Intl.message(
      'placeholder',
      name: 'fillRandomArtistPriority',
    );
  }
  String get neverFillQueue {
    return Intl.message(
      'placeholder',
      name: 'neverFillQueue',
    );
  }
  String get developer {
    return Intl.message(
      'placeholder',
      name: 'developer',
    );
  }
  String get showSnackBar {
    return Intl.message(
      'placeholder',
      name: 'showSnackBar',
    );
  }
  String get snackBarTest {
    return Intl.message(
      'placeholder',
      name: 'snackBarTest',
    );
  }
  String get showErrorSnackBar {
    return Intl.message(
      'placeholder',
      name: 'showErrorSnackBar',
    );
  }
  String get errorSnackBarTest {
    return Intl.message(
      'placeholder',
      name: 'errorSnackBarTest',
    );
  }


  //Metadatapage.dart
  String get metadataInformation {
    return Intl.message(
      'placeholder',
      name: 'metadataInformation',
    );
  }
  String get filePath {
    return Intl.message(
      'placeholder',
      name: 'filePath',
    );
  }


  //EditMetadataPage.dart
  String get albums {
    return Intl.message(
      'placeholder',
      name: 'albums',
    );
  }  
  String get albumsAppear {
    return Intl.message(
      'placeholder',
      name: 'albumsAppear',
    );
  }
  String get confirmRemoveFromBlacklist {
    return Intl.message(
      'placeholder',
      name: 'confirmRemoveFromBlacklist',
    );
  }  
  String get removeThem {
    return Intl.message(
      'placeholder',
      name: 'removeThem',
    );
  }
  String get currentlyPlaying {
    return Intl.message(
      'placeholder',
      name: 'currentlyPlaying',
    );
  }  
  String get addToPlaylist {
    return Intl.message(
      'placeholder',
      name: 'addToPlaylist',
    );
  }
  String get errorSnapshot {
    return Intl.message(
      'placeholder',
      name: 'errorSnapshot',  
    );
  }
  String get noImagePath {
    return Intl.message(
      'placeholder',
      name: 'noImagePath',  
    );
  }
  String get trackArtist {
    return Intl.message(
      'placeholder',
      name: 'trackArtist',  
    );
  }
  String get albumArtist {
    return Intl.message(
      'placeholder',
      name: 'albumArtist',  
    );
  }
  String get discNumber {
    return Intl.message(
      'placeholder',
      name: 'discNumber',  
    );
  }

  String get queueEmpty {
    return Intl.message(
      'placeholder',
      name: 'queueEmpty',  
    );
  }

  String get searchPrompt {
    return Intl.message(
      'placeholder',
      name: 'searchPrompt',  
    );
  }
  String get songsDash {
    return Intl.message(
      'placeholder',
      name: 'songsDash',
    );
  }
  String get playlistsDash {
    return Intl.message(
      'placeholder',
      name: 'playlistsDash',
    );
  }
  String get albumsDash {
    return Intl.message(
      'placeholder',
      name: 'albumsDash',
    );
  }

  String get songs {
    return Intl.message(
      'placeholder',
      name: 'songs',
    );
  }
  String get sortByArtist {
    return Intl.message(
      'placeholder',
      name: 'sortByArtist',
    );
  }
  String get sortByAlbum {
    return Intl.message(
      'placeholder',
      name: 'sortByAlbum',
    );
  }
	
  String get watchDirectories {
    return Intl.message(
      'placeholder',
      name: 'watchDirectories',
    );
  }
  String get watchDirectoriesEmpty {
    return Intl.message(
      'placeholder',
      name: 'watchDirectoriesEmpty',
    );
  }


  String get nullSong {
    return Intl.message(
      'placeholder',
      name: 'null',  
    );
  }

  String get settings {
    return Intl.message(
      'placeholder',
      name: 'settings',  
    );
  }
  String get general {
    return Intl.message(
      'placeholder',
      name: 'general',  
    );
  }
  String get addMusic {
    return Intl.message(
      'placeholder',
      name: 'addMusic',  
    );
  }
  String get refreshMetadata {
    return Intl.message(
      'placeholder',
      name: 'refreshMetadata',  
    );
  }
  String get backupDatabase {
    return Intl.message(
      'placeholder',
      name: 'backupDatabase',  
    );
  }
  String get login {
    return Intl.message(
      'placeholder',
      name: 'login',  
    );
  }
  String get createAccount {
    return Intl.message(
      'placeholder',
      name: 'createAccount',  
    );
  }
  String get uploadToCloud {
    return Intl.message(
      'placeholder',
      name: 'uploadToCloud',  
    );
  }
  String get downloadFromCloud {
    return Intl.message(
      'placeholder',
      name: 'downloadFromCloud',  
    );
  }
  String get logOut {
    return Intl.message(
      'placeholder',
      name: 'logOut',  
    );
  }
  String get userLoggedOut {
    return Intl.message(
      'placeholder',
      name: 'userLoggedOut',  
    );
  }


  String get appearance {
    return Intl.message(
      'placeholder',
      name: 'appearance',  
    );
  }

  String get darkMode {
    return Intl.message(
      'placeholder',
      name: 'darkMode',  
    );
  }

  String get songAddedToQueue {
    return Intl.message(
      'placeholder',
      name: 'songAddedToQueue',  
    );
  }

  String get youtubeDownload {
    return Intl.message(
      'placeholder',
      name: 'youtubeDownload',
    );
  }

  String get enterURLHere {
    return Intl.message(
      'placeholder',
      name: 'enterURLHere',
    );
  }

  String get couldNotLoadImage404 {
    return Intl.message(
      'placeholder',
      name: 'couldNotLoadImage404',
    );
  }


  String get author {
    return Intl.message(
      'placeholder',
      name: 'author',
    );
  }

  String get duration {
    return Intl.message(
      'placeholder',
      name: 'duration',
    );
  }

  String get dl {
    return Intl.message(
      'placeholder',
      name: 'dl',
    );
  }

  String get codec {
    return Intl.message(
      'placeholder',
      name: 'codec',
    );
  }

  String get size {
    return Intl.message(
      'placeholder',
      name: 'size',
    );
  }
  String get bitrateShort{
    return Intl.message(
      'placeholder',
      name: 'bitrateShort',
    );
  }

  String get downloadError {
    return Intl.message(
      'placeholder',
      name: 'downloadError',
    );
  }

  String get encodingError {
    return Intl.message(
      'placeholder',
      name: 'encodingError',
    );
  }

  String get noThumbnail {
    return Intl.message(
      'placeholder',
      name: 'noThumbnail',
    );
  }


  //SettingsDrawer.dart
  String get blacklistSetting{
    return Intl.message(
      'placeholder',
      name: 'blacklistSetting',
    );
  }

  String get syncWithFirebase {
    return Intl.message(
      'placeholder',
      name: 'syncWithFirebase',
    );
  }

  String get other {
    return Intl.message(
      'placeholder',
      name: 'other',
    );
  }

}
