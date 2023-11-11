// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle":
            MessageLookupByLibrary.simpleMessage("DMUS - French App Title"),
        "close": MessageLookupByLibrary.simpleMessage("Fermer"),
        "createdPlaylist":
            MessageLookupByLibrary.simpleMessage("Playlist créée"),
        "editMetadata":
            MessageLookupByLibrary.simpleMessage("Modifier les métadonnées"),
        "editPlaylist":
            MessageLookupByLibrary.simpleMessage("Modifier la playlist"),
        "error": MessageLookupByLibrary.simpleMessage(
            "Quelque chose s\'est mal passé !"),
        "lookupMetadata":
            MessageLookupByLibrary.simpleMessage("Rechercher des métadonnées"),
        "noSongs": MessageLookupByLibrary.simpleMessage(
            "Rien n\'est ici !\nAppuyez sur le + en haut à droite pour importer de la musique."),
        "pageTitle":
            MessageLookupByLibrary.simpleMessage("DMUS - Page d\'accueil"),
        "playNow": MessageLookupByLibrary.simpleMessage("Jouer maintenant"),
        "queueAll": MessageLookupByLibrary.simpleMessage(
            "Mettre tout en file d\'attente"),
        "songImported":
            MessageLookupByLibrary.simpleMessage("Chanson importée:"),
        "title": MessageLookupByLibrary.simpleMessage("DMUS - French Title"),
        "updatedPlaylist":
            MessageLookupByLibrary.simpleMessage("Playlist modifiée"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("Voir les détails")
      };
}
