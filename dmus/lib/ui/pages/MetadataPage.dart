
import 'dart:io';
import 'dart:typed_data';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/dialogs/context/MetadataContextDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class MetadataPage extends StatelessWidget {

  final DataEntity entity;

  const MetadataPage({super.key, required this.entity});



  Widget buildSongMetadataPage(BuildContext context) {

    Song song = (entity as Song);
    Metadata metadata = song.metadata;

    String? trackName = metadata.trackName ?? song.title;
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
    int? trackDuration =metadata.trackDuration;
    int? bitrate = metadata.bitrate;

    Uint8List? art = metadata.albumArt;


    return Scaffold(
        appBar: AppBar(
          title: const Text('Metadata Information'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.more),
          //     onPressed: () async {
          //       await showDialog(context: context, builder: (ctx) => MetadataContextDialog(songContext: song));
          //     },
          //   ),
          // ],
        ),
        body: ListView(
          children: [

            if(art != null)
              Image.memory(art),

            if(art == null && song.pictureCacheKey != null)
              FutureBuilder<File?>(
                future: ImageCacheController.getImagePathFromRaw(song.pictureCacheKey!),
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {

                  if (snapshot.connectionState != ConnectionState.done ) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if(!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data != null) {
                    return Image.file(snapshot.data!, fit: BoxFit.cover, );
                  }

                  return const Text('No image path found.');
                },
              ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Property')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Track Name')),
                    DataCell(Text(trackName)),
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
                    DataCell(Text(trackDuration == null ? LocalizationMapper.current.nA : formatDuration(Duration(milliseconds: trackDuration)))),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Bitrate (bits/sec)')),
                    DataCell(Text(bitrate?.toString() ?? LocalizationMapper.current.nA)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Mime Type')),
                    DataCell(Text(mimeType ?? LocalizationMapper.current.nA)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('File Path')),
                    DataCell(Text(song.file.path)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Year')),
                    DataCell(Text(year == null ? LocalizationMapper.current.nA : year.toString())),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Genre')),
                    DataCell(Text(genre ?? LocalizationMapper.current.nA)),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Track Number')),
                    DataCell(Text(trackNumber == null ? LocalizationMapper.current.nA : trackNumber.toString())),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Disk Number')),
                    DataCell(Text(discNumber == null ? LocalizationMapper.current.nA : discNumber.toString())),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Author Name')),
                    DataCell(Text(authorName?? 'N/A')),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Writer Name')),
                    DataCell(Text(writerName ?? 'N/A')),
                  ]),
                ],
              ),
            ),
          ],
        )
    );
  }


  Widget buildPlaylistMetadataPage(BuildContext context) {
    return Container();
  }

  Widget buildAlbumMetadataPage(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {

    switch(entity.entityType) {
      case EntityType.playlist:
        return buildPlaylistMetadataPage(context);
      case EntityType.album:
        return buildAlbumMetadataPage(context);
      case EntityType.song:
        return buildSongMetadataPage(context);
    }
  }
}
