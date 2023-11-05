


import 'package:dmus/core/data/musicbrainz/ResponseData.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';

class SearchYesNoPicker extends StatelessWidget {

  final SearchResult search;

  const SearchYesNoPicker({super.key, required this.search});

  List<DataRow> dataRowsForArtist(BuildContext context, List<ArtistCredit> artists) {

    return artists.map((e) =>

      DataRow(cells: [
        const DataCell(Text('Artist')),
        DataCell(Text(e.toString())),
      ])).toList();
  }


  List<DataRow> dataRowsForTags(BuildContext context, List<Tag> tags) {

    return tags.map((e) =>

      DataRow(cells: [
        const DataCell(Text('Tag')),
        DataCell(Text(e.toString())),
      ])).toList();
  }

  List<DataRow> dataRowsForRelease(BuildContext context, ReleaseSearchResult releaseSearch) {
    return [
      DataRow(cells: [
        const DataCell(Text('Release Title')),
        DataCell(Text(releaseSearch.title ?? 'N/A')),
      ]),

      if(releaseSearch.artistCredit != null)
        ...dataRowsForArtist(context, releaseSearch.artistCredit!),

      DataRow(cells: [
        const DataCell(Text('Release Group')),
        DataCell(Text(releaseSearch.releaseGroup?.toString() ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Release Date')),
        DataCell(Text(releaseSearch.date ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Track Count')),
        DataCell(Text(releaseSearch.trackCount?.toString() ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Release Country')),
        DataCell(Text(releaseSearch.country ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Release Status')),
        DataCell(Text(releaseSearch.status ?? 'N/A')),
      ]),

      if(releaseSearch.tags != null)
        ...dataRowsForTags(context, releaseSearch.tags!),

      DataRow(cells: [
        const DataCell(Text('ID')),
        DataCell(Text(search.id ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Status ID')),
        DataCell(Text(releaseSearch.statusId ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Packaging ID')),
        DataCell(Text(releaseSearch.packagingId ?? 'N/A')),
      ]),
    ];
  }


  List<DataRow> dataRowsForRecording(BuildContext context, RecordingSearchResponse recordingsSearch) {
    return [
      DataRow(cells: [
        const DataCell(Text('Title')),
        DataCell(Text(recordingsSearch.title ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('First Release Date')),
        DataCell(Text(recordingsSearch.firstReleaseDate ?? 'N/A')),
      ]),
      DataRow(cells: [
        const DataCell(Text('Length')),
        DataCell(Text(recordingsSearch.length?.toString() ?? 'N/A')),
      ]),

      if(recordingsSearch.artistCredit != null)
        ...dataRowsForArtist(context, recordingsSearch.artistCredit!),

      if(recordingsSearch.releases != null)
        for(var i in recordingsSearch.releases!)
        ...dataRowsForRelease(context, i)
    ];
  }

  List<DataRow> dataRowsForSearch(BuildContext context) {

    switch(search.searchResultType) {

      case SearchResultType.release:
        return dataRowsForRelease(context, search as ReleaseSearchResult);

      case SearchResultType.recording:
        return dataRowsForRecording(context, search as RecordingSearchResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Search Result"),
        centerTitle: true,
      ),
      body: Column(
      children: [
        Flexible(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Property')),
                    DataColumn(label: Text('Value')),
                  ],
                  rows: dataRowsForSearch(context)
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){
              popNavigatorSafeWithArgs(context, true);
            }, child: const Text("Use")),
            ElevatedButton(onPressed: (){
              popNavigatorSafeWithArgs(context, false);
            }, child: const Text("Cancel"))
          ],
        )
      ],
    ),
    );
  }
}