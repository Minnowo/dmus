




import 'package:dmus/ui/dialogs/context/ShareContextDialog.dart';
import 'package:flutter/material.dart';

import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';
import '../Util.dart';
import '../lookfeel/Animations.dart';
import '../pages/SelectedPlaylistPage.dart';
import 'context/AlbumsContextDialog.dart';
import 'context/PlaylistContextDialog.dart';
import 'form/PlaylistCreationForm.dart';


Future<void> createPlaylistFrom(BuildContext context, List<Song> s) async {

  Playlist p = Playlist(id: 0, title: "");
  p.songs.addAll(s);

  PlaylistCreationFormResult? result = await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: p));

  if(result == null) {
    return;
  }

  await ImportController.createPlaylist(result.title, result.songs);
}

Future<void> createPlaylistFromQueue(BuildContext context) async {
  await createPlaylistFrom(context, JustAudioController.instance.queueView);
}

/// Creates a playlist from the user
Future<void> createPlaylist(BuildContext context) async {

  PlaylistCreationFormResult? result = await animateOpenFromBottom<PlaylistCreationFormResult?>(context, const PlaylistCreationForm());

  if(result == null) {
    return;
  }

  await ImportController.createPlaylist(result.title, result.songs);
}


/// Edits a playlist from the user
///
/// Creates playlist if it does not exist
Future<void> editPlaylist(BuildContext context, Playlist playlist) async {

  PlaylistCreationFormResult? result = await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: playlist));

  if (result == null) {
    return;
  }

  if(result.playlistId != null) {
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

  PlaylistCreationFormResult? result = await animateOpenFromBottom<PlaylistCreationFormResult?>(context, PlaylistCreationForm(editing: playlist));

  if (result == null) {
    return null;
  }

  if(result.playlistId != null) {
    playlist.id = result.playlistId!;
    playlist.songs = result.songs;
    playlist.title = result.title;
    return await ImportController.updatePlaylistInDb(playlist);
  }
  return null;
}


/// Plays a playlist and pop the navigator
Future<void> popNavigatorPlayPlaylist(BuildContext context, Playlist p) async {

  popNavigatorSafe(context);
  await JustAudioController.instance.playPlaylist(p);
}


/// Queue a playlist and pop the navigator
void popNavigatorQueuePlaylist(BuildContext context, Playlist p) {

  popNavigatorSafe(context);
  JustAudioController.instance.queuePlaylist(p);
}


/// Opens the playlist page for the given playlist
void openPlaylistPage(BuildContext context, Playlist playlist) {

  animateOpenFromBottom(context, SelectedPlaylistPage(playlistContext: playlist));
}


/// Shows a playlist or album context menu from the given playlist
void showPlaylistOrAlbumContextMenu(BuildContext context, Playlist playlist) {

  if(playlist is Album) {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            AlbumsContextDialog( playlistContext: playlist)
    );

  } else {

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) =>
            PlaylistContextDialog( playlistContext: playlist)
    );
  }
}


/// Pop the navigator and show the share dialog
void popShowShareDialog(BuildContext context, DataEntity toShare) {

  popNavigatorSafe(context);
  ShareContextDialog.showAsDialog(context, toShare);
}

