


import 'dart:ffi';

import 'package:dmus/core/data/musicbrainz/ResponseData.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Search Result"),
        centerTitle: true,
      ),
      body: buildForSearch(context),
    );
  }
  
  Widget buildForSearch(BuildContext context) {

    switch(search.searchResultType) {

      case SearchResultType.release:
        return buildForRelease(context);
      case SearchResultType.recording:

        return buildForRecording(context);
    }
  }

  Widget buildForRecording(BuildContext context) {

    throw UnimplementedError();
  }

  Widget buildForRelease(BuildContext context) {

    ReleaseSearchResult rSearch = search as ReleaseSearchResult;

    return Column(
      children: [
        Flexible(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              // columnSpacing: 20.0, // Adjust spacing as needed
              // dataRowHeight: 40.0, // Adjust row height as needed
              columns: const [
                DataColumn(label: Text('Property')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('Title')),
                  DataCell(Text(rSearch.title ?? 'N/A')),
                ]),

                if(rSearch.artistCredit != null)
                  ...dataRowsForArtist(context, rSearch.artistCredit!),

                DataRow(cells: [
                  const DataCell(Text('Release Group')),
                  DataCell(Text(rSearch.releaseGroup?.toString() ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Date')),
                  DataCell(Text(rSearch.date ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Track Count')),
                  DataCell(Text(rSearch.trackCount?.toString() ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Country')),
                  DataCell(Text(rSearch.country ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Status')),
                  DataCell(Text(rSearch.status ?? 'N/A')),
                ]),

                if(rSearch.tags != null)
                  ...dataRowsForTags(context, rSearch.tags!),

                DataRow(cells: [
                  const DataCell(Text('ID')),
                  DataCell(Text(search.id ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Status ID')),
                  DataCell(Text(rSearch.statusId ?? 'N/A')),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Packaging ID')),
                  DataCell(Text(rSearch.packagingId ?? 'N/A')),
                ]),
              ],
            ),
          ),
        ),),
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
    );
  }
}