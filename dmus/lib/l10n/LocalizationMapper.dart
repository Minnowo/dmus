//From: https://stackoverflow.com/questions/51803755/getting-buildcontext-in-flutter-for-localization

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
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

  String get title {
    return Intl.message(
      'Hello World',
      name: 'LocalizationMapper Title',
      desc: 'Title for the Demo application',
    );
  }
  String get songImported {
    return Intl.message(
      'placeholder',
      name: 'songImported',
      desc: 'Song imported on Songs page',
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

// Future<Null> main() async {
//   final Locale myLocale = Locale(Platform.localeName);
//   await LocalizationMapper.load(myLocale);
//   runApp(MyApplication());
// }