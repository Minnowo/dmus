import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';
import '../../../generated/l10n.dart';
import '../picker/DataEntityPicker.dart';

class PlaylistCreationFormResult {
  final int? playlistId;
  final List<Song> songs;
  final String title;

  const PlaylistCreationFormResult({this.playlistId, required this.title, required this.songs});
}

class PlaylistCreationForm extends StatefulWidget {
  final Playlist? editing;

  const PlaylistCreationForm({super.key, this.editing});

  const PlaylistCreationForm.editExisting({super.key, required this.editing});

  @override
  State<PlaylistCreationForm> createState() => _PlaylistCreationFormState();
}

class _PlaylistCreationFormState extends State<PlaylistCreationForm> {
  final _formKey = GlobalKey<FormState>();
  final _playlistTitleTextController = TextEditingController();

  // used to generate unique keys for the dismissible items
  // this only changes when you dismiss an item,
  // so the keys created from redrawing are the same everytime
  // this prevents breaking the reorder and inkwell
  // this value is suuuper small, it would take forever to actually have it wrap around to the starting value causing an error
  int _stupidUniqueKeyForDismissible = minInteger;
  List<Song> selectedSongs = [];

  late final String title;
  static const int maxTitleLength = 512;

  @override
  void initState() {
    super.initState();

    if (widget.editing != null) {
      title = S.current.editPlaylist;
      _playlistTitleTextController.text = widget.editing!.title;

      selectedSongs.addAll(widget.editing!.songs);
    } else {
      title = S.current.createPlaylist;
    }
  }

  void addSongsPicker() {
    showDialog(context: context, builder: (ctx) => const SongPicker()).then((value) {
      logging.info("Got songs from picker: $value");

      if (value == null) return;

      selectedSongs.addAll(value);
    }).whenComplete(() => setState(() {}));
  }

  void finishPlaylist() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final PlaylistCreationFormResult result;

    if (widget.editing != null) {
      result = PlaylistCreationFormResult(
          playlistId: widget.editing!.id, title: _playlistTitleTextController.text, songs: selectedSongs);
    } else {
      result = PlaylistCreationFormResult(title: _playlistTitleTextController.text, songs: selectedSongs);
    }

    popNavigatorSafeWithArgs<PlaylistCreationFormResult>(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [IconButton(onPressed: addSongsPicker, icon: const Icon(Icons.add))],
      ),
      body: SafeArea(
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
                      child: TextFormField(
                          decoration: InputDecoration(labelText: S.current.playlistTitle),
                          controller: _playlistTitleTextController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return S.current.emptyTitleError;
                            }
                            if (value.length > maxTitleLength) {
                              return "${S.current.titleMaxLengthError} $maxTitleLength";
                            }
                            return null;
                          })),
                  if (selectedSongs.isEmpty)
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: HORIZONTAL_PADDING,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(S.current.selectedSongsIsEmpty, textAlign: TextAlign.center),
                              ],
                            )))
                  else
                    Expanded(
                        child: ReorderableListView.builder(
                      itemCount: selectedSongs.length,
                      itemBuilder: (context, index) {
                        var song = selectedSongs[index];

                        return Dismissible(
                          key: ValueKey(_stupidUniqueKeyForDismissible + index + 1),
                          onDismissed: (_) {
                            setState(() {
                              _stupidUniqueKeyForDismissible += selectedSongs.length;
                              selectedSongs.removeAt(index);
                            });
                          },
                          child: InkWell(
                            child: ListTile(
                              title: Text(song.title),
                              // subtitle: Text(subtitleFromMetadata(song.metadata)),
                              trailing: Text(formatDuration(song.duration)),

                              leading: ReorderableDragStartListener(
                                key: ValueKey(index),
                                index: index,
                                child: const Icon(Icons.drag_handle),
                              ),
                            ),
                            onTap: () {},
                          ),
                        );
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > selectedSongs.length) {
                          newIndex = selectedSongs.length;
                        }
                        if (oldIndex < newIndex) newIndex--;

                        setState(() {
                          final Song item = selectedSongs.removeAt(oldIndex);
                          selectedSongs.insert(newIndex, item);
                        });
                      },
                    ))
                ],
              ))),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            tooltip: S.current.pickSongs,
            onPressed: addSongsPicker,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: null,
            tooltip: S.current.savePlaylist,
            onPressed: finishPlaylist,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
