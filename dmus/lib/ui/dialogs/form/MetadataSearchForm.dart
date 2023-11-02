
import 'package:dmus/core/data/musicbrainz/SearchAPI.dart';
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
  static const String title = "Metadata Lookup";

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
      return "Search Cannot Be Empty!";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(title),
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
                        return const Text("Error fetching search results");
                      }

                      if(snapshot.connectionState != ConnectionState.done || !snapshot.hasData ) {
                       return const CircularProgressIndicator();
                      }

                      if((snapshot.data?.length ?? 0) <= 0) {
                        return const Text("There are no results for this search! :(");
                      }

                      final songMetadata = snapshot.data!;

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {

                            var dataRaw = songMetadata[index];

                            switch(dataRaw.searchResultType) {
                              case SearchResultType.recording:
                                final data = dataRaw as RecordingSearchResponse;
                                return ListTile(
                                  title: Text(data.title ?? "N/A"),
                                  subtitle: Text(data.artistCredit?.join(", ") ?? "N/A"),
                                  trailing: Text(data.score?.toString() ?? "N/A"),
                                );

                              case SearchResultType.release:
                                final data = dataRaw as ReleaseSearchResult;
                                return ListTile(
                                  title: Text(data.title ?? "N/A"),
                                  subtitle: Text(data.artistCredit?.join(", ") ?? "N/A"),
                                  trailing: Text(data.score?.toString() ?? "N/A"),
                                );
                            }
                          });
                    })
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                  DropdownButton(
                      value: _selectedValue,
                      items: const [
                        DropdownMenuItem(
                            value: 0,
                            child: Text("Releases")),
                        DropdownMenuItem(
                            value: 1,
                            child: Text("Recordings"))
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
                        decoration: const InputDecoration(labelText: 'Playlist Title'),
                        controller: _searchTextController,
                        validator: validateSearch
                    )),
              ],
            )
        ) ,
      floatingActionButton: FloatingActionButton(
          tooltip: 'Search',
          child: const Icon(Icons.save),
          onPressed: performSearch
      ),
    );
  }
}
