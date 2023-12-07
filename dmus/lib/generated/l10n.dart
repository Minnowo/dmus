// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Updated playlist`
  String get updatedPlaylist {
    return Intl.message(
      'Updated playlist',
      name: 'updatedPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Created playlist`
  String get createdPlaylist {
    return Intl.message(
      'Created playlist',
      name: 'createdPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Song Imported`
  String get songImported {
    return Intl.message(
      'Song Imported',
      name: 'songImported',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong!`
  String get error {
    return Intl.message(
      'Something went wrong!',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Error:`
  String get errorShort {
    return Intl.message(
      'Error:',
      name: 'errorShort',
      desc: '',
      args: [],
    );
  }

  /// `Metadata Information`
  String get metadataInformation {
    return Intl.message(
      'Metadata Information',
      name: 'metadataInformation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Metadata`
  String get editMetadata {
    return Intl.message(
      'Edit Metadata',
      name: 'editMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Lookup Metadata`
  String get lookupMetadata {
    return Intl.message(
      'Lookup Metadata',
      name: 'lookupMetadata',
      desc: '',
      args: [],
    );
  }

  /// `Add to Queue`
  String get addToQueue {
    return Intl.message(
      'Add to Queue',
      name: 'addToQueue',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Play Now`
  String get playNow {
    return Intl.message(
      'Play Now',
      name: 'playNow',
      desc: '',
      args: [],
    );
  }

  /// `Queue All`
  String get queueAll {
    return Intl.message(
      'Queue All',
      name: 'queueAll',
      desc: '',
      args: [],
    );
  }

  /// `Edit Playlist`
  String get editPlaylist {
    return Intl.message(
      'Edit Playlist',
      name: 'editPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Search cannot be empty!`
  String get searchEmpty {
    return Intl.message(
      'Search cannot be empty!',
      name: 'searchEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Error fetching search results`
  String get searchError {
    return Intl.message(
      'Error fetching search results',
      name: 'searchError',
      desc: '',
      args: [],
    );
  }

  /// `There are no results for this search! :(`
  String get noSearchResults {
    return Intl.message(
      'There are no results for this search! :(',
      name: 'noSearchResults',
      desc: '',
      args: [],
    );
  }

  /// `Releases`
  String get releases {
    return Intl.message(
      'Releases',
      name: 'releases',
      desc: '',
      args: [],
    );
  }

  /// `Recordings`
  String get recordings {
    return Intl.message(
      'Recordings',
      name: 'recordings',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `title cannot be empty!`
  String get emptyTitleError {
    return Intl.message(
      'title cannot be empty!',
      name: 'emptyTitleError',
      desc: '',
      args: [],
    );
  }

  /// `title should be less than`
  String get titleMaxLengthError {
    return Intl.message(
      'title should be less than',
      name: 'titleMaxLengthError',
      desc: '',
      args: [],
    );
  }

  /// `Use the + in the top right to add songs`
  String get selectedSongsIsEmpty {
    return Intl.message(
      'Use the + in the top right to add songs',
      name: 'selectedSongsIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Increment`
  String get increment {
    return Intl.message(
      'Increment',
      name: 'increment',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Selection`
  String get confirmSelection {
    return Intl.message(
      'Confirm Selection',
      name: 'confirmSelection',
      desc: '',
      args: [],
    );
  }

  /// `Add Files`
  String get addFiles {
    return Intl.message(
      'Add Files',
      name: 'addFiles',
      desc: '',
      args: [],
    );
  }

  /// `Add Folder`
  String get addFolder {
    return Intl.message(
      'Add Folder',
      name: 'addFolder',
      desc: '',
      args: [],
    );
  }

  /// `Artist`
  String get artist {
    return Intl.message(
      'Artist',
      name: 'artist',
      desc: '',
      args: [],
    );
  }

  /// `Tag`
  String get tag {
    return Intl.message(
      'Tag',
      name: 'tag',
      desc: '',
      args: [],
    );
  }

  /// `ReleaseTitle`
  String get releaseTitle {
    return Intl.message(
      'ReleaseTitle',
      name: 'releaseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search Result`
  String get searchResult {
    return Intl.message(
      'Search Result',
      name: 'searchResult',
      desc: '',
      args: [],
    );
  }

  /// `Property`
  String get property {
    return Intl.message(
      'Property',
      name: 'property',
      desc: '',
      args: [],
    );
  }

  /// `Value`
  String get value {
    return Intl.message(
      'Value',
      name: 'value',
      desc: '',
      args: [],
    );
  }

  /// `Track Name`
  String get trackName {
    return Intl.message(
      'Track Name',
      name: 'trackName',
      desc: '',
      args: [],
    );
  }

  /// `Track Artist Names`
  String get trackArtistNames {
    return Intl.message(
      'Track Artist Names',
      name: 'trackArtistNames',
      desc: '',
      args: [],
    );
  }

  /// `Album Name`
  String get albumName {
    return Intl.message(
      'Album Name',
      name: 'albumName',
      desc: '',
      args: [],
    );
  }

  /// `Album Artist Name`
  String get albumArtistName {
    return Intl.message(
      'Album Artist Name',
      name: 'albumArtistName',
      desc: '',
      args: [],
    );
  }

  /// `Track Duration`
  String get trackDuration {
    return Intl.message(
      'Track Duration',
      name: 'trackDuration',
      desc: '',
      args: [],
    );
  }

  /// `Bitrate (bits/sec)`
  String get bitrate {
    return Intl.message(
      'Bitrate (bits/sec)',
      name: 'bitrate',
      desc: '',
      args: [],
    );
  }

  /// `Mime Type`
  String get mimeType {
    return Intl.message(
      'Mime Type',
      name: 'mimeType',
      desc: '',
      args: [],
    );
  }

  /// `File Path`
  String get filePath {
    return Intl.message(
      'File Path',
      name: 'filePath',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get genre {
    return Intl.message(
      'Genre',
      name: 'genre',
      desc: '',
      args: [],
    );
  }

  /// `Track Number`
  String get trackNumber {
    return Intl.message(
      'Track Number',
      name: 'trackNumber',
      desc: '',
      args: [],
    );
  }

  /// `Disk Number`
  String get diskNumber {
    return Intl.message(
      'Disk Number',
      name: 'diskNumber',
      desc: '',
      args: [],
    );
  }

  /// `Author Name`
  String get authorName {
    return Intl.message(
      'Author Name',
      name: 'authorName',
      desc: '',
      args: [],
    );
  }

  /// `Writer Name`
  String get writerName {
    return Intl.message(
      'Writer Name',
      name: 'writerName',
      desc: '',
      args: [],
    );
  }

  /// `Use`
  String get use {
    return Intl.message(
      'Use',
      name: 'use',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Filter songs...`
  String get filterSongs {
    return Intl.message(
      'Filter songs...',
      name: 'filterSongs',
      desc: '',
      args: [],
    );
  }

  /// `Pick Songs`
  String get pickSongs {
    return Intl.message(
      'Pick Songs',
      name: 'pickSongs',
      desc: '',
      args: [],
    );
  }

  /// `Filter playlists...`
  String get filterPlaylists {
    return Intl.message(
      'Filter playlists...',
      name: 'filterPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Pick Playlists`
  String get pickPlaylists {
    return Intl.message(
      'Pick Playlists',
      name: 'pickPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `Save the Playlist`
  String get savePlaylist {
    return Intl.message(
      'Save the Playlist',
      name: 'savePlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Upload Songs`
  String get uploadSongs {
    return Intl.message(
      'Upload Songs',
      name: 'uploadSongs',
      desc: '',
      args: [],
    );
  }

  /// `Playback Speed`
  String get playbackSpeed {
    return Intl.message(
      'Playback Speed',
      name: 'playbackSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to do a full metadata refresh?`
  String get metadataRefreshConfirm {
    return Intl.message(
      'Are you sure you want to do a full metadata refresh?',
      name: 'metadataRefreshConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Refresh Metadata`
  String get refreshMetadata {
    return Intl.message(
      'Refresh Metadata',
      name: 'refreshMetadata',
      desc: '',
      args: [],
    );
  }

  /// `The path`
  String get pathAlreadyExists1 {
    return Intl.message(
      'The path',
      name: 'pathAlreadyExists1',
      desc: '',
      args: [],
    );
  }

  /// `already exists`
  String get pathAlreadyExists2 {
    return Intl.message(
      'already exists',
      name: 'pathAlreadyExists2',
      desc: '',
      args: [],
    );
  }

  /// `Exported Database to`
  String get exportedDatabase {
    return Intl.message(
      'Exported Database to',
      name: 'exportedDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get minPasswordLen {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'minPasswordLen',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email cannot be empty`
  String get emailEmpty {
    return Intl.message(
      'Email cannot be empty',
      name: 'emailEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty`
  String get passwordEmpty {
    return Intl.message(
      'Password cannot be empty',
      name: 'passwordEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Nothing is here!\nHit the + in the top right to create an album.`
  String get noAlbums {
    return Intl.message(
      'Nothing is here!\nHit the + in the top right to create an album.',
      name: 'noAlbums',
      desc: '',
      args: [],
    );
  }

  /// `All songs downloaded`
  String get allSongsDownloaded {
    return Intl.message(
      'All songs downloaded',
      name: 'allSongsDownloaded',
      desc: '',
      args: [],
    );
  }

  /// `Nothing is here!\nHit the + in the top right to import music.`
  String get noSongs {
    return Intl.message(
      'Nothing is here!\nHit the + in the top right to import music.',
      name: 'noSongs',
      desc: '',
      args: [],
    );
  }

  /// `Files which are blocked from being imported will show up here.\nYou can add or delete them using the buttons in the top.`
  String get blacklistPageHelperText {
    return Intl.message(
      'Files which are blocked from being imported will show up here.\nYou can add or delete them using the buttons in the top.',
      name: 'blacklistPageHelperText',
      desc: '',
      args: [],
    );
  }

  /// `Blacklisted Files`
  String get blacklistPageTitle {
    return Intl.message(
      'Blacklisted Files',
      name: 'blacklistPageTitle',
      desc: '',
      args: [],
    );
  }

  /// `Cannot play`
  String get cannotPlaySongFile1 {
    return Intl.message(
      'Cannot play',
      name: 'cannotPlaySongFile1',
      desc: '',
      args: [],
    );
  }

  /// `because it does not exist!`
  String get cannotPlaySongFile2 {
    return Intl.message(
      'because it does not exist!',
      name: 'cannotPlaySongFile2',
      desc: '',
      args: [],
    );
  }

  /// `Cannot play audio!`
  String get cannotPlayAudio {
    return Intl.message(
      'Cannot play audio!',
      name: 'cannotPlayAudio',
      desc: '',
      args: [],
    );
  }

  /// `External storage folder is null!`
  String get externalFolderNull {
    return Intl.message(
      'External storage folder is null!',
      name: 'externalFolderNull',
      desc: '',
      args: [],
    );
  }

  /// `Cannot create downloads folder`
  String get cannotCreateDownloadsFolder {
    return Intl.message(
      'Cannot create downloads folder',
      name: 'cannotCreateDownloadsFolder',
      desc: '',
      args: [],
    );
  }

  /// `Downloading songs...`
  String get downloadingSongs {
    return Intl.message(
      'Downloading songs...',
      name: 'downloadingSongs',
      desc: '',
      args: [],
    );
  }

  /// `Could not write to songs json metadata`
  String get couldNotWriteSongs {
    return Intl.message(
      'Could not write to songs json metadata',
      name: 'couldNotWriteSongs',
      desc: '',
      args: [],
    );
  }

  /// `There are no songs to upload!`
  String get noSongsToUpload {
    return Intl.message(
      'There are no songs to upload!',
      name: 'noSongsToUpload',
      desc: '',
      args: [],
    );
  }

  /// `Uploading songs...`
  String get uploadingSongs {
    return Intl.message(
      'Uploading songs...',
      name: 'uploadingSongs',
      desc: '',
      args: [],
    );
  }

  /// `All songs uploaded!`
  String get songsUploaded {
    return Intl.message(
      'All songs uploaded!',
      name: 'songsUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Uploading playlists!`
  String get uploadingPlaylists {
    return Intl.message(
      'Uploading playlists!',
      name: 'uploadingPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `All playlists uploaded!`
  String get playlistsUploaded {
    return Intl.message(
      'All playlists uploaded!',
      name: 'playlistsUploaded',
      desc: '',
      args: [],
    );
  }

  /// `Could not get a temporary directory!`
  String get noTemporaryDirectory {
    return Intl.message(
      'Could not get a temporary directory!',
      name: 'noTemporaryDirectory',
      desc: '',
      args: [],
    );
  }

  /// `Checking`
  String get checkingDirectories1 {
    return Intl.message(
      'Checking',
      name: 'checkingDirectories1',
      desc: '',
      args: [],
    );
  }

  /// `watch directories...`
  String get checkingDirectories2 {
    return Intl.message(
      'watch directories...',
      name: 'checkingDirectories2',
      desc: '',
      args: [],
    );
  }

  /// `Song`
  String get songPathDoesNotExist1 {
    return Intl.message(
      'Song',
      name: 'songPathDoesNotExist1',
      desc: '',
      args: [],
    );
  }

  /// `does not exist, it will be removed from the app.`
  String get songPathDoesNotExist2 {
    return Intl.message(
      'does not exist, it will be removed from the app.',
      name: 'songPathDoesNotExist2',
      desc: '',
      args: [],
    );
  }

  /// `Cannot import song because the file does not exist`
  String get cannotImportSongDoesNotExist {
    return Intl.message(
      'Cannot import song because the file does not exist',
      name: 'cannotImportSongDoesNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Cannot import song event though it was just imported!`
  String get dbError {
    return Intl.message(
      'Cannot import song event though it was just imported!',
      name: 'dbError',
      desc: '',
      args: [],
    );
  }

  /// `Importing`
  String get importingSongs1 {
    return Intl.message(
      'Importing',
      name: 'importingSongs1',
      desc: '',
      args: [],
    );
  }

  /// `songs...`
  String get importingSongs2 {
    return Intl.message(
      'songs...',
      name: 'importingSongs2',
      desc: '',
      args: [],
    );
  }

  /// `No files found in this folder!`
  String get noFilesInFolder {
    return Intl.message(
      'No files found in this folder!',
      name: 'noFilesInFolder',
      desc: '',
      args: [],
    );
  }

  /// `No permission to list files in this directory!`
  String get noPermissionInDirectory {
    return Intl.message(
      'No permission to list files in this directory!',
      name: 'noPermissionInDirectory',
      desc: '',
      args: [],
    );
  }

  /// `Cannot create playlist with an empty name!`
  String get emptyName {
    return Intl.message(
      'Cannot create playlist with an empty name!',
      name: 'emptyName',
      desc: '',
      args: [],
    );
  }

  /// `Cannot edit playlist with an empty name or which does not exist!`
  String get cannotEditPlaylist {
    return Intl.message(
      'Cannot edit playlist with an empty name or which does not exist!',
      name: 'cannotEditPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Delete Playlist`
  String get deletePlaylist {
    return Intl.message(
      'Delete Playlist',
      name: 'deletePlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this playlist?`
  String get confirmPlaylistDelete {
    return Intl.message(
      'Are you sure you want to delete this playlist?',
      name: 'confirmPlaylistDelete',
      desc: '',
      args: [],
    );
  }

  /// `Playlist`
  String get playlistRemoved1 {
    return Intl.message(
      'Playlist',
      name: 'playlistRemoved1',
      desc: '',
      args: [],
    );
  }

  /// `has been removed from the app`
  String get playlistRemoved2 {
    return Intl.message(
      'has been removed from the app',
      name: 'playlistRemoved2',
      desc: '',
      args: [],
    );
  }

  /// `Share File`
  String get shareFile {
    return Intl.message(
      'Share File',
      name: 'shareFile',
      desc: '',
      args: [],
    );
  }

  /// `Share Title`
  String get shareTitle {
    return Intl.message(
      'Share Title',
      name: 'shareTitle',
      desc: '',
      args: [],
    );
  }

  /// `Share Title + More`
  String get shareTitlePlus {
    return Intl.message(
      'Share Title + More',
      name: 'shareTitlePlus',
      desc: '',
      args: [],
    );
  }

  /// `Share Picture`
  String get sharePicture {
    return Intl.message(
      'Share Picture',
      name: 'sharePicture',
      desc: '',
      args: [],
    );
  }

  /// `Share All Song Titles`
  String get shareAllSongs {
    return Intl.message(
      'Share All Song Titles',
      name: 'shareAllSongs',
      desc: '',
      args: [],
    );
  }

  /// `Share All Song Titles + More`
  String get shareAllMore {
    return Intl.message(
      'Share All Song Titles + More',
      name: 'shareAllMore',
      desc: '',
      args: [],
    );
  }

  /// `Remove From Queue`
  String get removeQueue {
    return Intl.message(
      'Remove From Queue',
      name: 'removeQueue',
      desc: '',
      args: [],
    );
  }

  /// `Remove Song`
  String get removeSong {
    return Intl.message(
      'Remove Song',
      name: 'removeSong',
      desc: '',
      args: [],
    );
  }

  /// `Remove and block from reimport`
  String get removeAndBlock {
    return Intl.message(
      'Remove and block from reimport',
      name: 'removeAndBlock',
      desc: '',
      args: [],
    );
  }

  /// `has been added to the queue`
  String get titleAddedToQueue {
    return Intl.message(
      'has been added to the queue',
      name: 'titleAddedToQueue',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to block this song from the app? It will be skipped when importing again. You can allow it again from the blacklist under settings.`
  String get confirmBlockSong {
    return Intl.message(
      'Are you sure you want to block this song from the app? It will be skipped when importing again. You can allow it again from the blacklist under settings.',
      name: 'confirmBlockSong',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message(
      'Block',
      name: 'block',
      desc: '',
      args: [],
    );
  }

  /// `Keep`
  String get keep {
    return Intl.message(
      'Keep',
      name: 'keep',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove this song from the app?`
  String get confirmRemoveSong {
    return Intl.message(
      'Are you sure you want to remove this song from the app?',
      name: 'confirmRemoveSong',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message(
      'Remove',
      name: 'remove',
      desc: '',
      args: [],
    );
  }

  /// `Song`
  String get songRemoved1 {
    return Intl.message(
      'Song',
      name: 'songRemoved1',
      desc: '',
      args: [],
    );
  }

  /// `has been removed from the app`
  String get songRemoved2 {
    return Intl.message(
      'has been removed from the app',
      name: 'songRemoved2',
      desc: '',
      args: [],
    );
  }

  /// `Metadata Lookup`
  String get metadataLookup {
    return Intl.message(
      'Metadata Lookup',
      name: 'metadataLookup',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get nA {
    return Intl.message(
      'N/A',
      name: 'nA',
      desc: '',
      args: [],
    );
  }

  /// `Playlist Title`
  String get playlistTitle {
    return Intl.message(
      'Playlist Title',
      name: 'playlistTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Playlist`
  String get createPlaylist {
    return Intl.message(
      'Create Playlist',
      name: 'createPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Got songs from picker:`
  String get gotSongs {
    return Intl.message(
      'Got songs from picker:',
      name: 'gotSongs',
      desc: '',
      args: [],
    );
  }

  /// `Cannot find any storage!`
  String get noStorage {
    return Intl.message(
      'Cannot find any storage!',
      name: 'noStorage',
      desc: '',
      args: [],
    );
  }

  /// `Pick Files`
  String get pickFiles {
    return Intl.message(
      'Pick Files',
      name: 'pickFiles',
      desc: '',
      args: [],
    );
  }

  /// `Filter Filename`
  String get filterFilename {
    return Intl.message(
      'Filter Filename',
      name: 'filterFilename',
      desc: '',
      args: [],
    );
  }

  /// `Cannot access`
  String get cannotAccessDirectory1 {
    return Intl.message(
      'Cannot access',
      name: 'cannotAccessDirectory1',
      desc: '',
      args: [],
    );
  }

  /// `!! No permissions.`
  String get cannotAccessDirectory2 {
    return Intl.message(
      '!! No permissions.',
      name: 'cannotAccessDirectory2',
      desc: '',
      args: [],
    );
  }

  /// `Release Group`
  String get releaseGroup {
    return Intl.message(
      'Release Group',
      name: 'releaseGroup',
      desc: '',
      args: [],
    );
  }

  /// `Release Date`
  String get releaseDate {
    return Intl.message(
      'Release Date',
      name: 'releaseDate',
      desc: '',
      args: [],
    );
  }

  /// `Track Count`
  String get trackCount {
    return Intl.message(
      'Track Count',
      name: 'trackCount',
      desc: '',
      args: [],
    );
  }

  /// `Release Country`
  String get releaseCountry {
    return Intl.message(
      'Release Country',
      name: 'releaseCountry',
      desc: '',
      args: [],
    );
  }

  /// `Release Status`
  String get releaseStatus {
    return Intl.message(
      'Release Status',
      name: 'releaseStatus',
      desc: '',
      args: [],
    );
  }

  /// `ID`
  String get iD {
    return Intl.message(
      'ID',
      name: 'iD',
      desc: '',
      args: [],
    );
  }

  /// `Status ID`
  String get statusID {
    return Intl.message(
      'Status ID',
      name: 'statusID',
      desc: '',
      args: [],
    );
  }

  /// `Packaging ID`
  String get packagingID {
    return Intl.message(
      'Packaging ID',
      name: 'packagingID',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `First Release Date`
  String get firstReleaseDate {
    return Intl.message(
      'First Release Date',
      name: 'firstReleaseDate',
      desc: '',
      args: [],
    );
  }

  /// `Length`
  String get length {
    return Intl.message(
      'Length',
      name: 'length',
      desc: '',
      args: [],
    );
  }

  /// `Filter Name...`
  String get filterName {
    return Intl.message(
      'Filter Name...',
      name: 'filterName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address.`
  String get enterValidEmail {
    return Intl.message(
      'Please enter a valid email address.',
      name: 'enterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get passwordLength {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'passwordLength',
      desc: '',
      args: [],
    );
  }

  /// `Registration successful`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Registration failed. Error:`
  String get registrationFailed {
    return Intl.message(
      'Registration failed. Error:',
      name: 'registrationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Signed in:`
  String get signedIn {
    return Intl.message(
      'Signed in:',
      name: 'signedIn',
      desc: '',
      args: [],
    );
  }

  /// `Advanced Settings`
  String get advancedSettings {
    return Intl.message(
      'Advanced Settings',
      name: 'advancedSettings',
      desc: '',
      args: [],
    );
  }

  /// `Appearance`
  String get appearance {
    return Intl.message(
      'Appearance',
      name: 'appearance',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message(
      'Dark Mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Songs Page List Item Trails With`
  String get songsPageLITrail {
    return Intl.message(
      'Songs Page List Item Trails With',
      name: 'songsPageLITrail',
      desc: '',
      args: [],
    );
  }

  /// `Trail With Menu`
  String get trailMenu {
    return Intl.message(
      'Trail With Menu',
      name: 'trailMenu',
      desc: '',
      args: [],
    );
  }

  /// `Trail With Duration`
  String get trailDuration {
    return Intl.message(
      'Trail With Duration',
      name: 'trailDuration',
      desc: '',
      args: [],
    );
  }

  /// `Random`
  String get random {
    return Intl.message(
      'Random',
      name: 'random',
      desc: '',
      args: [],
    );
  }

  /// `Currently Playing Bar Swipe Mode`
  String get playBarSwipeMode {
    return Intl.message(
      'Currently Playing Bar Swipe Mode',
      name: 'playBarSwipeMode',
      desc: '',
      args: [],
    );
  }

  /// `Swipe to Stop`
  String get swipeStop {
    return Intl.message(
      'Swipe to Stop',
      name: 'swipeStop',
      desc: '',
      args: [],
    );
  }

  /// `Swipe for Next / Previous`
  String get swipeNext {
    return Intl.message(
      'Swipe for Next / Previous',
      name: 'swipeNext',
      desc: '',
      args: [],
    );
  }

  /// `Queue Fill Mode`
  String get queueMode {
    return Intl.message(
      'Queue Fill Mode',
      name: 'queueMode',
      desc: '',
      args: [],
    );
  }

  /// `Fill With Random`
  String get fillRandom {
    return Intl.message(
      'Fill With Random',
      name: 'fillRandom',
      desc: '',
      args: [],
    );
  }

  /// `Fill With Random Priority Same Artist`
  String get fillRandomArtistPriority {
    return Intl.message(
      'Fill With Random Priority Same Artist',
      name: 'fillRandomArtistPriority',
      desc: '',
      args: [],
    );
  }

  /// `Never Fill Queue`
  String get neverFillQueue {
    return Intl.message(
      'Never Fill Queue',
      name: 'neverFillQueue',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `Backup Database`
  String get backupDatabase {
    return Intl.message(
      'Backup Database',
      name: 'backupDatabase',
      desc: '',
      args: [],
    );
  }

  /// `Show SnackBar`
  String get showSnackBar {
    return Intl.message(
      'Show SnackBar',
      name: 'showSnackBar',
      desc: '',
      args: [],
    );
  }

  /// `This is a snackbar`
  String get snackBarTest {
    return Intl.message(
      'This is a snackbar',
      name: 'snackBarTest',
      desc: '',
      args: [],
    );
  }

  /// `Show Error SnackBar`
  String get showErrorSnackBar {
    return Intl.message(
      'Show Error SnackBar',
      name: 'showErrorSnackBar',
      desc: '',
      args: [],
    );
  }

  /// `This is an error`
  String get errorSnackBarTest {
    return Intl.message(
      'This is an error',
      name: 'errorSnackBarTest',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password. Please try again.`
  String get incorrectPassword {
    return Intl.message(
      'Incorrect password. Please try again.',
      name: 'incorrectPassword',
      desc: '',
      args: [],
    );
  }

  /// `Email not found. Please check your email address.`
  String get emailNotFound {
    return Intl.message(
      'Email not found. Please check your email address.',
      name: 'emailNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Sign-In Error:`
  String get signInError {
    return Intl.message(
      'Sign-In Error:',
      name: 'signInError',
      desc: '',
      args: [],
    );
  }

  /// `wrong-password`
  String get wrongPassword {
    return Intl.message(
      'wrong-password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `user-not-found`
  String get userNotFound {
    return Intl.message(
      'user-not-found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Albums`
  String get albums {
    return Intl.message(
      'Albums',
      name: 'albums',
      desc: '',
      args: [],
    );
  }

  /// `Albums will appear as you import music!`
  String get albumsAppear {
    return Intl.message(
      'Albums will appear as you import music!',
      name: 'albumsAppear',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to remove these files from the blacklist?`
  String get confirmRemoveFromBlacklist {
    return Intl.message(
      'Are you sure you want to remove these files from the blacklist?',
      name: 'confirmRemoveFromBlacklist',
      desc: '',
      args: [],
    );
  }

  /// `Remove them`
  String get removeThem {
    return Intl.message(
      'Remove them',
      name: 'removeThem',
      desc: '',
      args: [],
    );
  }

  /// `Currently Playing`
  String get currentlyPlaying {
    return Intl.message(
      'Currently Playing',
      name: 'currentlyPlaying',
      desc: '',
      args: [],
    );
  }

  /// `ADD TO PLAYLIST`
  String get addToPlaylist {
    return Intl.message(
      'ADD TO PLAYLIST',
      name: 'addToPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `No image path found.`
  String get noImagePath {
    return Intl.message(
      'No image path found.',
      name: 'noImagePath',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'sp'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
