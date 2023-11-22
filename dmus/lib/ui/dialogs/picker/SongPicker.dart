



import 'package:dmus/core/Util.dart';
import 'package:dmus/core/localstorage/dbimpl/TableSong.dart';
import 'package:dmus/l10n/DemoLocalizations.dart';
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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    TableSong.selectAllWithMetadata()
        .then((value) => value.map((e) => SelectableDataItem(e, false, true)))
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
          title: Text(DemoLocalizations.of(context).pickSongs),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: finishSelection,
                icon: const Icon(Icons.check)
            )
          ],
        ),
        body:  Column(
          children: [

            Expanded(
              child: ListView(
                children: [

                  for(final tuple in songs)
                    if(tuple.isVisible)
                      InkWell(
                        child: CheckboxListTile(
                          title: Text(tuple.item.title),
                          subtitle: Text(subtitleFromMetadata(tuple.item.metadata)),
                          value: tuple.isSelected,
                          enableFeedback: true,
                          onChanged: (checked){

                            if(checked != null && checked) {
                              tuple.isSelected = true;
                            } else {
                              tuple.isSelected = false;
                            }

                            setState(() { });
                          },
                        ),
                      ),

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child:
              TextField(
                controller: _searchController,
                onChanged: _filter,
                decoration: InputDecoration(
                  hintText: 'Filter Name...',
                  suffixIcon: IconButton(
                    onPressed: () => _filter(""),
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:  Padding(
            padding: EdgeInsets.only(bottom: 24 + 16 * 2),
            child: FloatingActionButton(
              onPressed: finishSelection,
              child: const Icon(Icons.save),
            )
        )

    );
  }


  void _filter(String text) {

    if(text.isEmpty) {
      for(final i in songs){
        i.isVisible = true;
      }
      return setState(() { });
    }

    for(final s in text.toLowerCase().split("\s+")) {
      for(final i in songs) {

        bool matches = i.item.title.toLowerCase().contains(s) || subtitleFromMetadata(i.item.metadata).toLowerCase().contains(s);

        if(matches) {
          i.isVisible = true;
        } else {
          i.isVisible = false;
        }
      }
    }

    setState(() { });
  }
}