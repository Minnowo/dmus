import 'dart:io';

import 'package:dmus/core/data/UIEnumSettings.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/dialogs/context/ShareContextDialog.dart';
import 'package:dmus/ui/dialogs/picker/ConfirmDestructiveAction.dart';
import 'package:dmus/ui/dialogs/picker/DataEntityPicker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as Path;

import '../../../generated/l10n.dart';
import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/data/FileDialog.dart';
import '../../core/localstorage/DatabaseController.dart';
import '../../core/localstorage/ImportController.dart';
import '../Util.dart';
import '../lookfeel/Animations.dart';
import '../lookfeel/CommonTheme.dart';
import '../pages/SelectedPlaylistPage.dart';
import 'context/AlbumsContextDialog.dart';
import 'context/PlaylistContextDialog.dart';
import 'form/PlaylistCreationForm.dart';

Future<void> createPlaylistFrom(BuildContext context, List<Song> s) async {
  Playlist p = Playlist.withSongs(id: 0, title: "", songs: s);

  PlaylistCreationFormResult? result =
      await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: p));

  if (result == null) {
    return;
  }

  await p.setPictureCacheKey(null);
  await ImportController.createPlaylist(result.title, result.songs);
}

Future<void> createPlaylistFromQueue(BuildContext context) async {
  await createPlaylistFrom(context, JustAudioController.instance.queueView);
}

/// Creates a playlist from the user
Future<void> createPlaylist(BuildContext context) async {
  PlaylistCreationFormResult? result =
      await animateOpenFromBottom<PlaylistCreationFormResult?>(context, const PlaylistCreationForm());

  if (result == null) {
    return;
  }

  await ImportController.createPlaylist(result.title, result.songs);
}

/// Edits a playlist from the user
///
/// Creates playlist if it does not exist
Future<void> editPlaylist(BuildContext context, Playlist playlist) async {
  PlaylistCreationFormResult? result =
      await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: playlist));

  if (result == null) {
    return;
  }

  if (result.playlistId != null) {
    await ImportController.editPlaylist(result.playlistId!, result.title, result.songs);
  } else {
    await ImportController.createPlaylist(result.title, result.songs);
  }
}

/// Updates an existing playlist from the user
///
/// Returns the updated playlist
///
/// Returns null if the user cancels or the updated playlist has no id
Future<Playlist?> updateExistingPlaylist(BuildContext context, Playlist playlist) async {
  PlaylistCreationFormResult? result =
      await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: playlist));

  if (result == null) {
    return null;
  }

  if (result.playlistId != null) {
    playlist.id = result.playlistId!;
    playlist.songs = result.songs;
    playlist.title = result.title;
    playlist.updateDuration();
    return await ImportController.updatePlaylistInDb(playlist);
  }
  return null;
}

/// Plays a playlist and pop the navigator
Future<void> popNavigatorPlayPlaylist(BuildContext context, Playlist p) async {
  popNavigatorSafe(context);

  switch (SettingsHandler.playlistQueueFillMode) {
    case PlaylistQueueFillMode.neverFill:
      JustAudioController.instance.setAutofillQueueWhen(FILL_QUEUE_NEVER);
      break;

    case PlaylistQueueFillMode.fillWithRandom:
      JustAudioController.instance.setAutofillQueueWhen(FILL_QUEUE_WHEN);
      break;
  }

  await JustAudioController.instance.playPlaylist(p);
}

/// Queue a playlist and pop the navigator
void popNavigatorQueuePlaylist(BuildContext context, Playlist p) {
  popNavigatorSafe(context);
  JustAudioController.instance.queuePlaylist(p);
}

void popNavigatorQueuePlaylistNext(BuildContext context, Playlist p) {
  popNavigatorSafe(context);
  JustAudioController.instance.queuePlaylistNext(p);
}

/// Opens the playlist page for the given playlist
void openPlaylistPage(BuildContext context, Playlist playlist) {
  animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlist));
}

/// Shows a playlist or album context menu from the given playlist
void showPlaylistOrAlbumContextMenu(BuildContext context, Playlist playlist) {
  if (playlist is Album) {
    showModalBottomSheet(
        context: context, builder: (BuildContext context) => AlbumsContextDialog(playlistContext: playlist));
  } else {
    showModalBottomSheet(
        context: context, builder: (BuildContext context) => PlaylistContextDialog(playlistContext: playlist));
  }
}

/// Pop the navigator and show the share dialog
void popShowShareDialog(BuildContext context, DataEntity toShare) {
  popNavigatorSafe(context);
  ShareContextDialog.showAsDialog(context, toShare);
}

void ShowShareDialog(BuildContext context, DataEntity toShare) {
  ShareContextDialog.showAsDialog(context, toShare);
}

Future<void> refreshMetadata(BuildContext context) async {
  popNavigatorSafe(context);

  final r = await showDialog(
      context: context,
      builder: (ctx) => ConfirmDestructiveAction(
          promptText: S.current.metadataRefreshConfirm,
          yesText: S.current.refreshMetadata,
          noText: S.current.cancel,
          yesTextColor: RED,
          noTextColor: null));

  if (r == null || !r) {
    return;
  }

  await ImportController.reimportAll();
}

Future<void> backupDatabase(BuildContext context) async {
  pickDirectory().then((value) async {
    if (value == null) return;

    File databaseExport = File(Path.join(value, DatabaseController.databaseFilename));

    logging.info(databaseExport);

    if (await databaseExport.exists()) {
      logging.warning("Cannot save file because it already exists");

      if (context.mounted) {
        showSnackBarWithDuration(context,
            "${S.current.pathAlreadyExists1} $databaseExport ${S.current.pathAlreadyExists2}", longSnackBarDuration);
      }
      return;
    }

    if (await DatabaseController.backupDatabase(databaseExport)) {
      if (context.mounted) {
        showSnackBarWithDuration(context, "${S.current.exportedDatabase} $databaseExport", longSnackBarDuration);
      }
    }
  });
}

/// Selects any number of playlists and adds the given song to them
Future<void> selectPlaylistAndAddSong(BuildContext context, Song s) async {
  Iterable<Playlist>? result = await showDialog(context: context, builder: (ctx) => const PlaylistPicker());

  if (result == null) return;

  for (final p in result) {
    p.songs.add(s);
    p.duration += s.duration;
    p.setPictureCacheKey(null);

    ImportController.updatePlaylistInDb(p);
  }
}
