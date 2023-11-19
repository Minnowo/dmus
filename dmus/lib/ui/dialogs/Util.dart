




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';
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
