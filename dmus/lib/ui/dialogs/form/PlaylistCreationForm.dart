

import 'dart:math';

import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/SongPicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/localstorage/dbimpl/TableSong.dart';


class PlaylistCreationFormResult {

  final int? playlistId;
  final List<Song> songs;
  final String title;

  const PlaylistCreationFormResult({this.playlistId, required this.title, required this.songs});
}

class PlaylistCreationForm extends StatefulWidget {

  final Playlist? editing;

  const PlaylistCreationForm({Key? key, this.editing}) : super(key: key);

  const PlaylistCreationForm.editExisting({Key? key, required this.editing}) : super(key: key);

  @override
  State<PlaylistCreationForm> createState() => _PlaylistCreationFormState();
}

class _PlaylistCreationFormState extends State<PlaylistCreationForm> {

  final _formKey = GlobalKey<FormState>();
  final _playlistTitleTextController = TextEditingController();

  List<Song> selectedSongs = [];

  static const String title = "Create Playlist";
  static const double pad = 15.0;
  static const int maxTitleLength = 512;

  @override
  void initState() {
    super.initState();

    if(widget.editing != null) {

      _playlistTitleTextController.text = widget.editing!.title;

      selectedSongs.addAll(widget.editing!.songs);
    }
  }


  void addSongsPicker(){

    showDialog(context: context, builder: (ctx) => const SongPicker())
        .then((value) {

          logging.info("Got songs from picker: $value");

          if(value == null) return;

          selectedSongs.addAll(value);

    }).whenComplete(() => setState(() { }));
  }

  void finishPlaylist(){

    if(_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;

    }

    final PlaylistCreationFormResult result;

    if(widget.editing != null) {
      result = PlaylistCreationFormResult(playlistId: widget.editing!.id, title: _playlistTitleTextController.text, songs: selectedSongs);
    } else {
      result = PlaylistCreationFormResult(title: _playlistTitleTextController.text, songs: selectedSongs);
    }

    popNavigatorSafeWithArgs<PlaylistCreationFormResult>(context, result);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
              onPressed: addSongsPicker,
              icon: const Icon(Icons.add))
        ],
      ),
      body: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(pad),
                  child: TextFormField(
                      decoration: const InputDecoration(labelText: 'Playlist Title'),
                      controller: _playlistTitleTextController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "title cannot be empty!";
                        }
                        if (value.length > maxTitleLength) {
                          return "title should be less than $maxTitleLength";
                        }
                        return null;
                      }
                  )),

              if(selectedSongs.isEmpty)
                const Expanded(
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text("Use the + in the top right to add songs"),
                      ],
                    )
                )

              else
                Expanded(
                    child: ReorderableListView.builder(
                      itemCount: selectedSongs.length,
                      itemBuilder: (context, index) {
                        var song = selectedSongs[index];

                        return ListTile(
                          key: Key(index.toString()),
                          title: Text(song.title),
                          // subtitle: Text(subtitleFromMetadata(song.metadata)),
                          trailing: Text(formatDuration(song.duration)),

                          leading: ReorderableDragStartListener(
                            key: ValueKey<Song>(song),
                            index: index,
                            child: const Icon(Icons.drag_handle),
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {

                        if (newIndex > selectedSongs.length) newIndex = selectedSongs.length;
                        if (oldIndex < newIndex) newIndex--;

                        setState(() {

                          final Song item = selectedSongs.removeAt(oldIndex);
                          selectedSongs.insert(newIndex, item);
                        });
                      },
                    )
                )
            ],
          )
      ) ,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          onPressed: finishPlaylist,
          child: const Icon(Icons.save),
      )
    );
  }
}



