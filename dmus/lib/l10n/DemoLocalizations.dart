//i18n -> internationalization
//l10n -> localization

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple example of localizing a Flutter app written with the
// Dart intl package (see https://pub.dev/packages/intl).
//
// French and English (locale language codes 'en' and 'fr') are
// supported.

// The pubspec.yaml file must include flutter_localizations and the
// Dart intl packages in its dependencies section. For example:
//
// dependencies:
//   flutter:
//   sdk: flutter
//  flutter_localizations:
//    sdk: flutter
//  intl: any # Use the pinned version from flutter_localizations

// If you run this app with the device's locale set to anything but
// English or Spanish, the app's locale will be English. If you
// set the device's locale to Spanish, the app's locale will be
// Spanish.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

// This file was generated in two steps, using the Dart intl tools. With the
// app's root directory (the one that contains pubspec.yaml) as the current
// directory:
//
// flutter pub get
// dart run intl_translation:extract_to_arb --output-dir=lib/l10n lib/main.dart
// dart run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/main.dart lib/l10n/intl_*.arb
//
// The second command generates intl_messages.arb and the third generates
// messages_all.dart. There's more about this process in
// https://pub.dev/packages/intl.
import 'package:dmus/generated/intl/messages_all.dart';

// #docregion DemoLocalizations
class DemoLocalizations {
  DemoLocalizations(this.localeName);

  static Future<DemoLocalizations> load(Locale locale) {
    final String name =
    locale.countryCode == null || locale.countryCode!.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((_) {
      return DemoLocalizations(localeName);
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

  final String localeName;

  //Localization getters

  //main.dart
  String get title {
    return Intl.message(
      'placeholder',
      name: 'title',
      desc: 'Title for the DMUS application',
      locale: localeName,
    );
  }
  String get songImported {
    return Intl.message(
      'placeholder',
      name: 'songImported',
      desc: 'Song imported on Songs page',
      locale: localeName,
    );
  }
  String get createdPlaylist {
    return Intl.message(
      'placeholder',
      name: 'createdPlaylist',
      desc: 'Playlist created',
      locale: localeName,
    );
  }
  String get updatedPlaylist {
    return Intl.message(
      'placeholder',
      name: 'updatedPlaylist',
      desc: 'Playlist updated',
      locale: localeName,
    );
  }
  String get error {
    return Intl.message(
      'placeholder',
      name: 'error',
      desc: 'Standard error message',
      locale: localeName,
    );
  }

  //MetadataContextDialogue.dart
  String get editMetadata {
    return Intl.message(
      'placeholder',
      name: 'editMetadata',
      desc: 'Song metadata edited',
      locale: localeName,
    );
  }
  String get lookupMetadata {
    return Intl.message(
      'placeholder',
      name: 'lookupMetadata',
      desc: 'Search song metadata',
      locale: localeName,
    );
  }

  //PlaylistContextDialog.dart
  String get viewDetails {
    return Intl.message(
      'placeholder',
      name: 'viewDetails',
      desc: 'View song details in playlist',
      locale: localeName,
    );
  }
  String get playNow {
    return Intl.message(
      'placeholder',
      name: 'playNow',
      desc: 'Play song',
      locale: localeName,
    );
  }
  String get queueAll {
    return Intl.message(
      'placeholder',
      name: 'queueAll',
      desc: 'Queue all songs in playlist',
      locale: localeName,
    );
  }
  String get editPlaylist {
    return Intl.message(
      'placeholder',
      name: 'editPlaylist',
      desc: 'Edit current playlist',
      locale: localeName,
    );
  }
  String get close {
    return Intl.message(
      'placeholder',
      name: 'close',
      desc: 'Close playlist',
      locale: localeName,
    );
  }

  //MetadataSearchForm.dart
  String get searchError {
    return Intl.message(
      'placeholder',
      name: 'searchError',
      desc: 'Error performing metadata search',
      locale: localeName,
    );
  }
  String get noSearchResults {
    return Intl.message(
      'placeholder',
      name: 'noSearchResults',
      desc: 'No search results were found',
      locale: localeName,
    );
  }
  String get releases {
    return Intl.message(
      'placeholder',
      name: 'releases',
      desc: 'Releases results',
      locale: localeName,
    );
  }
  String get recordings {
    return Intl.message(
      'placeholder',
      name: 'recordings',
      desc: 'Recordings results',
      locale: localeName,
    );
  }
  String get search {
    return Intl.message(
      'placeholder',
      name: 'search',
      desc: 'Search button label',
      locale: localeName,
    );
  }

  //PlaylistCreationForm.dart
  String get playlistTitle {
    return Intl.message(
      'placeholder',
      name: 'playlistTitle',
      desc: 'Playlist title text entry label',
      locale: localeName,
    );
  }
  String get emptyTitleError {
    return Intl.message(
      'placeholder',
      name: 'emptyTitleError',
      desc: 'Error returned when user does not enter a title when making a playlist',
      locale: localeName,
    );
  }
  String get titleMaxLengthError {
    return Intl.message(
      'placeholder',
      name: 'titleMaxLengthError',
      desc: 'Error returned when user enters a playlist title longer than maximum character limit',
      locale: localeName,
    );
  }
  String get selectedSongsIsEmpty {
    return Intl.message(
      'placeholder',
      name: 'selectedSongsIsEmpty',
      desc: 'Message displayed when user has not selected any songs to add to a playlist',
      locale: localeName,
    );
  }
  String get increment {
    return Intl.message(
      'placeholder',
      name: 'increment',
      desc: 'Tooltip that displays the text increment',
      locale: localeName,
    );
  }

  //ImportDialogue.dart
  String get addFiles {
    return Intl.message(
      'placeholder',
      name: 'addFiles',
      desc: 'Button labelled Add Files',
      locale: localeName,
    );
  }
  String get addFolder {
    return Intl.message(
      'placeholder',
      name: 'addFolder',
      desc: 'Button labelled Add Folders',
      locale: localeName,
    );
  }

  //SearchYesNoPicker.dart
  String get searchResult {
    return Intl.message(
      'placeholder',
      name: 'searchResult',
      desc: 'Search Result label',
      locale: localeName,
    );
  }
  String get property {
    return Intl.message(
      'placeholder',
      name: 'property',
      desc: 'Property label',
      locale: localeName,
    );
  }
  String get value {
    return Intl.message(
      'placeholder',
      name: 'value',
      desc: 'Value label',
      locale: localeName,
    );
  }
  String get use {
    return Intl.message(
      'placeholder',
      name: 'use',
      desc: 'Button labelled Use',
      locale: localeName,
    );
  }
  String get cancel {
    return Intl.message(
      'placeholder',
      name: 'cancel',
      desc: 'Button labelled Cancel',
      locale: localeName,
    );
  }

  //SongPicker.dart
  String get pickSongs {
    return Intl.message(
      'placeholder',
      name: 'pickSongs',
      desc: 'Pick Songs button',
      locale: localeName,
    );
  }
  
  //SpeedModifierPicker.dart
  String get playbackSpeed {
    return Intl.message(
      'placeholder',
      name: 'playbackSpeed',
      desc: 'Playback Speed text form label',
      locale: localeName,
    );
  }
  String get ok {
    return Intl.message(
      'placeholder',
      name: 'ok',
      desc: 'Ok button',
      locale: localeName,
    );
  }
  
  //registerPage.dart
  String get enterValidEmail {
    return Intl.message(
      'placeholder',
      name: 'enterValidEmail',
      desc: 'Enter valid email label on registration or login page',
      locale: localeName,
    );
  }
  String get minPasswordLen {
    return Intl.message(
      'placeholder',
      name: 'minPasswordLen',
      desc: 'Password must be at least given length',
      locale: localeName,
    );
  }
  String get register {
    return Intl.message(
      'placeholder',
      name: 'register',
      desc: 'Register for new account button',
      locale: localeName,
    );
  }

  //SignIn.dart
  String get signIn {
    return Intl.message(
      'placeholder',
      name: 'signIn',
      desc: 'Sign In button',
      locale: localeName,
    );
  }
  String get email {
    return Intl.message(
      'placeholder',
      name: 'email',
      desc: 'Register for new account button',
      locale: localeName,
    );
  }
  String get emailEmpty {
    return Intl.message(
      'placeholder',
      name: 'emailEmpty',
      desc: 'Error text for email field on register and login page',
      locale: localeName,
    );
  }
  String get password {
    return Intl.message(
      'placeholder',
      name: 'password',
      desc: 'Register for new account button',
      locale: localeName,
    );
  }
  String get passwordEmpty {
    return Intl.message(
      'placeholder',
      name: 'passwordEmpty',
      desc: 'Error text for password field on register and login page',
      locale: localeName,
    );
  }

  //AlbumsPage.dart
  String get noAlbums {
    return Intl.message(
      'placeholder',
      name: 'noAlbums',
      desc: 'No albums available on the Albums page',
      locale: localeName,
    );
  }

  //SongsPage.dart
  String get noSongs {
    return Intl.message(
      'placeholder',
      name: 'noSongs',
      desc: 'No songs available on the Songs page',
      locale: localeName,
    );
  }

  
}
// #enddocregion DemoLocalizations

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) =>
      DemoLocalizations.load(locale);

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}