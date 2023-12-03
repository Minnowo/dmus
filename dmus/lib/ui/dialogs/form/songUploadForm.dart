

import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/data/DataEntity.dart';
import '../picker/DataEntityPicker.dart';


class SongUploadFormResult {
  final List<Song> songs;

  const SongUploadFormResult({required this.songs});
}

class SongUploadForm extends StatefulWidget {
  final Playlist? editing;

  const SongUploadForm({Key? key, this.editing}) : super(key: key);

  const SongUploadForm.editExisting({Key? key, required this.editing})
      : super(key: key);

  @override
  State<SongUploadForm> createState() => _SongUploadFormState();
}

class _SongUploadFormState extends State<SongUploadForm> {
  final _formKey = GlobalKey<FormState>();

  //final _playlistTitleTextController = TextEditingController();
  int _stupidUniqueKeyForDismissible = minInteger;
  List<Song> selectedSongs = [];

  static const String title = "Upload Songs";
  static const double pad = 15.0;
  static const int maxTitleLength = 512;

  @override
  void initState() {
    super.initState();

    if (widget.editing != null) {
      //_playlistTitleTextController.text = widget.editing!.title;

      selectedSongs.addAll(widget.editing!.songs);
    }
  }

  void addSongsPicker() {
    showDialog(
      context: context,
      builder: (ctx) => const SongPicker(),
    ).then((value) {
      logging.info("Got songs from picker: $value");

      if (value == null) return;

      selectedSongs.addAll(value);
    }).whenComplete(() => setState(() {}));
  }

  void finishSongUpload() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final SongUploadFormResult result = SongUploadFormResult(
        songs: selectedSongs);

    popNavigatorSafeWithArgs<SongUploadFormResult>(context, result);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(title),
        actions: [
          IconButton(
            onPressed: addSongsPicker,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Modified code block for showing empty selected songs
            if (selectedSongs.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    LocalizationMapper.current.selectedSongsIsEmpty,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ReorderableListView.builder(
                  itemCount: selectedSongs.length,
                  itemBuilder: (context, index) {
                    var song = selectedSongs[index];

                    return Dismissible(
                      key: ValueKey(
                        _stupidUniqueKeyForDismissible + index + 1,
                      ),
                      onDismissed: (_) {
                        setState(() {
                          _stupidUniqueKeyForDismissible +=
                              selectedSongs.length;
                          selectedSongs.removeAt(index);
                        });
                      },
                      child: InkWell(
                        child: ListTile(
                          title: Text(song.title),
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
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            tooltip: LocalizationMapper.current.increment,
            onPressed: addSongsPicker,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: null,
            tooltip: LocalizationMapper.current.increment,
            onPressed: finishSongUpload,
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}



