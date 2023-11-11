// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appTitle":
            MessageLookupByLibrary.simpleMessage("DMUS - English AppTitle"),
        "close": MessageLookupByLibrary.simpleMessage("Close"),
        "createdPlaylist":
            MessageLookupByLibrary.simpleMessage("Created playlist"),
        "editMetadata": MessageLookupByLibrary.simpleMessage("Edit Metadata"),
        "editPlaylist": MessageLookupByLibrary.simpleMessage("Edit Playlist"),
        "error": MessageLookupByLibrary.simpleMessage("Something went wrong!"),
        "lookupMetadata":
            MessageLookupByLibrary.simpleMessage("Lookup Metadata"),
        "noSongs": MessageLookupByLibrary.simpleMessage(
            "Nothing is here!\nHit the + in the top right to import music."),
        "pageTitle": MessageLookupByLibrary.simpleMessage("DMUS - Home Page"),
        "playNow": MessageLookupByLibrary.simpleMessage("Play Now"),
        "queueAll": MessageLookupByLibrary.simpleMessage("Queue All"),
        "songImported": MessageLookupByLibrary.simpleMessage("Song Imported:"),
        "title": MessageLookupByLibrary.simpleMessage("DMUS - English Title"),
        "updatedPlaylist":
            MessageLookupByLibrary.simpleMessage("Updated playlist"),
        "viewDetails": MessageLookupByLibrary.simpleMessage("View Details")
      };
}
