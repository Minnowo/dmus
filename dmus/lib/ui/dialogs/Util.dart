




import 'package:dmus/ui/dialogs/context/ShareContextDialog.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/JustAudioController.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';
import '../Util.dart';
import '../lookfeel/Animations.dart';
import '../pages/SelectedPlaylistPage.dart';
import 'context/AlbumsContextDialog.dart';
import 'context/PlaylistContextDialog.dart';
import 'form/PlaylistCreationForm.dart';


/// Creates a playlist from the user
Future<void> createPlaylist(BuildContext context) async {

  PlaylistCreationFormResult? result =  await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PlaylistCreationForm()));

  if(result == null) {
    return;
  }

  await ImportController.createPlaylist(result.title, result.songs);
}


/// Edits a playlist from the user
///
/// Creates playlist if it does not exist
Future<void> editPlaylist(BuildContext context, Playlist playlist) async {

  PlaylistCreationFormResult? result = await Navigator.push(context,
      MaterialPageRoute(builder: (ctx) => PlaylistCreationForm(editing: playlist,)));

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

  PlaylistCreationFormResult? result = await Navigator.push(context,
      MaterialPageRoute(builder: (ctx) => PlaylistCreationForm(editing: playlist,)));

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
Future<void> playPlaylist(BuildContext context, Playlist p) async {

  popNavigatorSafe(context);
  await JustAudioController.instance.stopAndEmptyQueue();
  await JustAudioController.instance.queuePlaylist(p);
  await JustAudioController.instance.playSongAt(0);
  await JustAudioController.instance.play();;
}


/// Queue a playlist and pop the navigator
Future<void> queuePlaylist(BuildContext context, Playlist p) async {

  popNavigatorSafe(context);
  await JustAudioController.instance.queuePlaylist(p);
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

DecorationImage? getDataEntityImageAsDecoration(DataEntity dataEntity) {

  if(dataEntity.artPath == null) {
    return null;
  }

  Image i = Image.file(dataEntity.artPath!, fit: BoxFit.cover,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {

        logging.warning("Could not load image for $dataEntity");

        return const Icon(Icons.music_note);
      });

  return DecorationImage(
      image: i.image
  );
}
