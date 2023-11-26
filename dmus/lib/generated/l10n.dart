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

  /// `Playlist Title`
  String get playlistTitle {
    return Intl.message(
      'Playlist Title',
      name: 'playlistTitle',
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

  /// `Pick Songs`
  String get pickSongs {
    return Intl.message(
      'Pick Songs',
      name: 'pickSongs',
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

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
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

  /// `Files which are blocked from being imported will show up here. You can add or delete them using the buttons in the top.`
  String get blacklistPageHelperText {
    return Intl.message(
      'Files which are blocked from being imported will show up here. You can add or delete them using the buttons in the top.',
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'fr'),
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
