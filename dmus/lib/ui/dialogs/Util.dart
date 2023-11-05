




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/ImportController.dart';
import 'form/PlaylistCreationForm.dart';


Future<void> createPlaylist(BuildContext context) async {

  PlaylistCreationFormResult? result =  await Navigator.push(context, MaterialPageRoute(builder: (ctx) => const PlaylistCreationForm()));

  if(result == null) {
    return;
  }

  await ImportController.createPlaylist(result.title, result.songs);
}

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