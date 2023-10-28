



import 'package:dmus/core/Util.dart';
import 'package:dmus/core/audio/AudioMetadata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class MetadataPage extends StatelessWidget {

  final Metadata metadata;

  MetadataPage({required this.metadata});

  @override
  Widget build(BuildContext context) {

    String? trackName = metadata.trackName;
    List<String>? trackArtistNames = metadata.trackArtistNames;
    String? albumName = metadata.albumName;
    String? albumArtistName = metadata.albumArtistName;
    int? trackNumber = metadata.trackNumber;
    // int? albumLength = metadata.albumLength; // i have no idea what this is
    int? year = metadata.year;
    String? genre = metadata.genre;
    String? authorName = metadata.authorName;
    String? writerName = metadata.writerName;
    int? discNumber = metadata.discNumber;
    String? mimeType = metadata.mimeType;
    Duration trackDuration = Duration(milliseconds: metadata.trackDuration ?? 0);
    int? bitrate = metadata.bitrate;

    return Scaffold(
      appBar: AppBar(
        title: Text('Metadata Information'),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20.0, // Adjust spacing as needed
            dataRowHeight: 40.0, // Adjust row height as needed
            columns: const [
              DataColumn(label: Text('Property')),
              DataColumn(label: Text('Value')),
            ],
            rows: [
              DataRow(cells: [
                const DataCell(Text('Track Name')),
                DataCell(Text(trackName ?? 'N/A')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Track Artist Names')),
                DataCell(Text(trackArtistNames?.join(', ') ?? 'N/A')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Album Name')),
                DataCell(Text(albumName ?? 'N/A')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Album Artist Name')),
                DataCell(Text(albumArtistName ?? 'N/A')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Track Duration')),
                DataCell(Text(formatDuration(trackDuration))),
              ]),
              DataRow(cells: [
                const DataCell(Text('Bitrate (bits/sec)')),
                DataCell(Text(bitrate?.toString() ?? "N/A")),
              ]),
              DataRow(cells: [
                const DataCell(Text('Mime Type')),
                DataCell(Text(mimeType ?? "N/A")),
              ]),
              DataRow(cells: [
                const DataCell(Text('Year')),
                DataCell(Text(year == null ? "N/A" : year.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Genre')),
                DataCell(Text(genre ?? "N/A")),
              ]),
              DataRow(cells: [
                const DataCell(Text('Track Number')),
                DataCell(Text(trackNumber == null ? "N/A" : trackNumber.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Disk Number')),
                DataCell(Text(discNumber == null ? "N/A" : discNumber.toString())),
              ]),
              DataRow(cells: [
                const DataCell(Text('Author Name')),
                DataCell(Text(authorName?? 'N/A')),
              ]),
              DataRow(cells: [
                const DataCell(Text('Writer Name')),
                DataCell(Text(writerName ?? 'N/A')),
              ]),
              // Add more rows for other metadata properties
            ],
          ),
        ),
      ),
    );

  }
}