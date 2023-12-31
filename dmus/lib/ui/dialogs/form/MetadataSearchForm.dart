
import 'package:dmus/core/data/musicbrainz/SearchAPI.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/dialogs/picker/SearchYesNoPicker.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';
import '../../../core/data/musicbrainz/ResponseData.dart';


class MetadataSearchPage extends StatefulWidget {
  const MetadataSearchPage({super.key});

  @override
  State<MetadataSearchPage> createState() => _MetadataSearchPageState();
}


class _MetadataSearchPageState extends State<MetadataSearchPage>
{
  static String title = LocalizationMapper.current.metadataLookup;

  final _formKey = GlobalKey<FormState>();
  final _searchTextController = TextEditingController();

  Future<List<SearchResult>> searchResults = Future(() => []);

  int _selectedValue = 0;

  void performSearch() {

    if(_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    final searchTerm = _searchTextController.text;

    logging.info("Searching for $searchTerm");

    setState(() {

      if(_selectedValue == SearchResultType.release.index) {

        logging.info("Searching in releases");
        searchResults = MusicBrainzSearchAPI.releaseSearchRaw(searchTerm, 20);
      }
      else if(_selectedValue == SearchResultType.recording.index) {

        logging.info("Searching in recordings");
        searchResults = MusicBrainzSearchAPI.recordingSearchRaw(searchTerm, 20);
      }
    });
  }

  String? validateSearch(String? search) {
    if (search == null || search.isEmpty) {
      return LocalizationMapper.current.searchEmpty;
    }
    return null;
  }

  Widget buildInkWellForSearch(SearchResult dataRaw) {

    String subtitle = LocalizationMapper.current.nA;

    switch(dataRaw.searchResultType) {

      case SearchResultType.release:
        subtitle = (dataRaw as ReleaseSearchResult).artistCredit?.join(", ") ?? LocalizationMapper.current.nA;
        break;

      case SearchResultType.recording:
        subtitle = (dataRaw as RecordingSearchResponse).artistCredit?.join(", ") ?? LocalizationMapper.current.nA;
        break;
    }

    return InkWell(
      child: ListTile(
              title: Text(dataRaw.title ?? LocalizationMapper.current.nA),
              subtitle: Text(subtitle),
              trailing: Text(dataRaw.score?.toString() ?? LocalizationMapper.current.nA),
            ),
      onTap: () {

        Navigator.push(context, MaterialPageRoute(builder: (ctx) => SearchYesNoPicker(search: dataRaw)))
        .then((value) {

          if(value == null || !value) {
            return;
          }

          popNavigatorSafeWithArgs(context, dataRaw);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ],
        ),
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                    child: FutureBuilder(future: searchResults, builder: (context, snapshot) {

                      if(snapshot.hasError) {
                        return Text(LocalizationMapper.current.searchError);
                      }

                      if(snapshot.connectionState != ConnectionState.done || !snapshot.hasData ) {
                       return const CircularProgressIndicator();
                      }

                      if((snapshot.data?.length ?? 0) <= 0) {
                        return Text(LocalizationMapper.current.noSearchResults);
                      }

                      final songMetadata = snapshot.data!;

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {

                            var dataRaw = songMetadata[index];

                            return buildInkWellForSearch(dataRaw);

                          });
                    })
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                  DropdownButton(
                      value: _selectedValue,
                      items: [
                        DropdownMenuItem(
                            value: 0,
                            child: Text(LocalizationMapper.current.releases)),
                        DropdownMenuItem(
                            value: 1,
                            child: Text(LocalizationMapper.current.recordings))
                      ],
                      onChanged:(value) {

                        setState(() {
                          _selectedValue = value as int;
                        });

                        logging.info("Changed to value $value");
                        logging.info("Changed to value ${value.runtimeType}");
                      }),
                ),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: LocalizationMapper.current.playlistTitle),
                        controller: _searchTextController,
                        validator: validateSearch
                    )),
              ],
            )
        ) ,
      floatingActionButton: FloatingActionButton(
          tooltip: LocalizationMapper.current.search,
          child: const Icon(Icons.save),
          onPressed: performSearch
      ),
    );
  }
}
