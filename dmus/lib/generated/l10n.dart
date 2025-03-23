import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class S {
  S();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
        _current != null, 'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static initLocale(Locale l) async {
    if (!AppLocalizations.delegate.isSupported(l)) {
      l = const Locale("en");
    }
    _current = await AppLocalizations.delegate.load(l);
  }

  static init() async {
    await initLocale(Locale(Intl.getCurrentLocale()));
  }
}
