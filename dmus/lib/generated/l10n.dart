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

  /// `DMUS - English Title`
  String get title {
    return Intl.message(
      'DMUS - English Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `DMUS - English AppTitle`
  String get appTitle {
    return Intl.message(
      'DMUS - English AppTitle',
      name: 'appTitle',
      desc: '',
      args: [],
    );
  }

  /// `DMUS - Home Page`
  String get pageTitle {
    return Intl.message(
      'DMUS - Home Page',
      name: 'pageTitle',
      desc: '',
      args: [],
    );
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

  /// `Song Imported:`
  String get songImported {
    return Intl.message(
      'Song Imported:',
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

  /// `Nothing is here!\nHit the + in the top right to import music.`
  String get noSongs {
    return Intl.message(
      'Nothing is here!\nHit the + in the top right to import music.',
      name: 'noSongs',
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
