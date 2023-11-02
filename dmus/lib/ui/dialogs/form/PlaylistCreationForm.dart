

import 'dart:math';

import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';
import '../../../core/localstorage/dbimpl/TableSong.dart';


class PlaylistCreationFormResult {
  final List<Song> songs;
  final String title;

  const PlaylistCreationFormResult({required this.title, required this.songs});
}

class PlaylistCreationForm extends StatefulWidget {

  final String? title;

  const PlaylistCreationForm({Key? key, this.title}) : super(key: key);

  const PlaylistCreationForm.editExisting({Key? key, required this.title}) : super(key: key);

  @override
  State<PlaylistCreationForm> createState() => _PlaylistCreationFormState();
}

class _PlaylistCreationFormState extends State<PlaylistCreationForm> {

  final _formKey = GlobalKey<FormState>();
  final _playlistTitleTextController = TextEditingController();

  List<Song> songsToSelect = [];
  List<Song> selectedSongs = [];

  static const String title = "Create Playlist";
  static const double pad = 15.0;
  static const int maxTitleLength = 512;

  @override
  void initState() {
    super.initState();

    if(widget.title != null) {
      _playlistTitleTextController.text = widget.title!;
    }

    TableSong.selectAllWithMetadata().then( (value) {

      songsToSelect.addAll(value);

    }).whenComplete(() => setState(() { }));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar( title: const Text(title), backgroundColor: Theme.of(context).colorScheme.inversePrimary, ),
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
              Expanded(
                  child: ListView.builder(
                      itemCount: songsToSelect.length,
                      itemBuilder: (context, index) {
                        var song = songsToSelect[index];
                        return InkWell(
                            child: CheckboxListTile(
                              title: Text(song.title),
                              // trailing: text(formatduration(song.duration)),
                              subtitle: Text(subtitleFromMetadata(song.metadata)),
                              onChanged: (checked) {
                                logging.finest("check changed for $song to value $checked");
                                if(checked != null && checked) {
                                  selectedSongs.add(song);
                                }
                                else {
                                  selectedSongs.remove(song);
                                }

                                setState(() { });
                              },
                              value: selectedSongs.contains(song),
                            ),
                            onTap: () async {
                            },
                            onLongPress: () {
                            }
                        );
                      }
                  )
              )
            ],
          )
      ) ,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: const Icon(Icons.save),
          onPressed: () {
            if(_formKey.currentState != null && _formKey.currentState!.validate()) {
              popNavigatorSafeWithArgs<PlaylistCreationFormResult>(context, PlaylistCreationFormResult(title: _playlistTitleTextController.text, songs: selectedSongs));
            }
          }),
    );
  }
}



