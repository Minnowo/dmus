



import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/provider/PlaylistProvider.dart';
import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/dialogs/picker/SelectionListPicker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/DataEntity.dart';


abstract class _DataEntityPickerState<T extends DataEntity> extends State<StatefulWidget> with SelectionListPicker<T> {

  final TextEditingController _filterController = TextEditingController();

  bool _selectAll = false;

  Widget buildListItem(SelectableDataItem<T> item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationMapper.current.pickSongs),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: toggleSelectAll,
            icon: const Icon(Icons.select_all),
          ),
          IconButton(
            onPressed: () => super.finishSelection(context),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (final tuple in items)
                  if (tuple.isVisible)
                    this.buildListItem(tuple),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _filterController,
              onChanged: filterDataEntities,
              decoration: InputDecoration(
                hintText: 'Filter Name...',
                suffixIcon: IconButton(
                  onPressed: () => filterDataEntities(""),
                  icon: const Icon(Icons.clear),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24 + 16 * 2),
        child: FloatingActionButton(
          onPressed: () => super.finishSelection(context),
          child: const Icon(Icons.save),
        ),
      ),
    );
  }


  void toggleSelectAll() {
    _selectAll = !_selectAll;
    setAllItemsSelection(_selectAll);
    setState(() {});
  }


  void filterDataEntities(String text) {

    super.filterItems(text, dataEntityMatches);

    setState(() { });
  }
}



class SongPicker extends StatefulWidget {
  const SongPicker({super.key});

  @override
  State<StatefulWidget> createState()  => _SongPickerState();
}

class _SongPickerState extends _DataEntityPickerState<Song> {

  @override
  void initState() {
    super.initState();

    items.addAll(
        context.read<SongsProvider>().songs
            .map((e) => SelectableDataItem(e, false, true)));
  }

  @override
  Widget buildListItem(SelectableDataItem<DataEntity> tuple) {
    return InkWell(
      child: CheckboxListTile(
        title: Text(tuple.item.title),
        value: tuple.isSelected,
        subtitle: Text(subtitleFromMetadata((tuple.item as Song).metadata)),
        enableFeedback: true,
        onChanged: (checked) {
          if (checked != null && checked) {
            tuple.isSelected = true;
          } else {
            tuple.isSelected = false;
          }
          setState(() {});
        },
      ),
    );
  }
}


class PlaylistPicker extends StatefulWidget {
  const PlaylistPicker({super.key});

  @override
  State<StatefulWidget> createState()  => _PlaylistPickerState();
}

class _PlaylistPickerState extends _DataEntityPickerState<Playlist> {

  @override
  void initState() {
    super.initState();

    items.addAll(
        context.read<PlaylistProvider>().playlists
            .map((e) => SelectableDataItem(e, false, true)));
  }

  @override
  Widget buildListItem(SelectableDataItem<DataEntity> tuple) {
    return InkWell(
      child: CheckboxListTile(
        title: Text(tuple.item.title),
        value: tuple.isSelected,
        enableFeedback: true,
        onChanged: (checked) {
          if (checked != null && checked) {
            tuple.isSelected = true;
          } else {
            tuple.isSelected = false;
          }
          setState(() {});
        },
      ),
    );
  }
}
