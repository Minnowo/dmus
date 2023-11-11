//i18n -> internationalization
//l10n -> localization

// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// A simple example of localizing a Flutter app written with the
// Dart intl package (see https://pub.dev/packages/intl).
//
// French France and English (locale language codes 'en' and 'fr_FR') are
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
      name: 'editPlatlist',
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