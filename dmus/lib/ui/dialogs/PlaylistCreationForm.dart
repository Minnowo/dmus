

import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/data/DataEntity.dart';
import '../../core/localstorage/dbimpl/TableSong.dart';

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
  final _playlistSongSelectionController = ();

  bool isSongSelecting = false;
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

  Widget buildTitleCreation(BuildContext context) {

    return Scaffold(
      appBar: AppBar( title: const Text(title), backgroundColor: Theme.of(context).colorScheme.inversePrimary, ),
      body: Padding(
        padding: const EdgeInsets.all(pad),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Playlist Title'),
                  controller: _playlistTitleTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    if (value.length > maxTitleLength) {
                      return "Title should be less than $maxTitleLength";
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: const Icon(Icons.save),
          onPressed: () {
            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
              setState(() => isSongSelecting = true);
            }
          }),
    );
  }

  Widget buildSongSelect(BuildContext context) {

    return Scaffold(
      appBar: AppBar( title: const Text(title), backgroundColor: Theme.of(context).colorScheme.inversePrimary, ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
            Expanded(
                child:ListView.builder(
                    itemCount: songsToSelect.length,
                    itemBuilder: (context, index) {
                      var song = songsToSelect[index];
                      return InkWell(
                          child: CheckboxListTile(
                            title: Text(song.title),
                            // trailing: Text(formatDuration(song.duration)),
                            subtitle: Text(subtitleFromMetadata(song.metadata)),
                            onChanged: (checked) {
                              logging.finest("Check changed for $song to value $checked");
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
                    })
            )
        ],
      ) ,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Increment',
          child: const Icon(Icons.save),
          onPressed: () {
            popNavigatorSafeWithArgs<List<Song>>(context, selectedSongs);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(isSongSelecting) {
      return buildSongSelect(context);
    }
    return buildTitleCreation(context);

  }
}



