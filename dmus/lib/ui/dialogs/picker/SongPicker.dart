



import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/data/DataEntity.dart';

class SongPicker extends StatefulWidget {
  const SongPicker({super.key});

  @override
  State<StatefulWidget> createState()  => _SongPickerState();
}

class _SongPickerState extends State<SongPicker> {

  List<SelectableDataItem<Song>> songs = [];

  @override
  void initState() {
    super.initState();

    TableSong.selectAllWithMetadata()
        .then((value) => value.map((e) => SelectableDataItem(e, false)))
        .then((value) => songs.addAll(value))
        .whenComplete(() => setState((){}));

  }

  void finishSelection(){

    popNavigatorSafeWithArgs(
        context,
        songs
            .where((element) => element.isSelected)
            .map((e) => e.item)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Pick Songs"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: finishSelection,
              icon: const Icon(Icons.check)
          )
        ],
      ),
      body: ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {

            final tuple = songs[index];

            return InkWell(
              key: Key(index.toString()),
              child: CheckboxListTile(
                title: Text(tuple.item.title),
                value: tuple.isSelected,
                onChanged: (checked){

                  if(checked != null && checked) {
                    tuple.isSelected = true;
                  } else {
                    tuple.isSelected = false;
                  }

                  setState(() { });
                },
              ),
            );
          }),

      floatingActionButton: FloatingActionButton(
        onPressed: finishSelection,
        child: const Icon(Icons.save),
      ),
    );
  }
}