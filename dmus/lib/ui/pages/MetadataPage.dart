
import 'dart:io';
import 'dart:typed_data';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import '/generated/l10n.dart';
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
          title: Text(S.current.metadataInformation),
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
                    return Text('${S.current.errorShort} ${snapshot.error}');
                  }

                  if(!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data != null) {
                    return Image.file(snapshot.data!, fit: BoxFit.cover, );
                  }

                  return Text(S.current.noImagePath);
                },
              ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(S.current.property)),
                  DataColumn(label: Text(S.current.value)),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(S.current.trackName)),
                    DataCell(Text(trackName)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.trackArtistNames)),
                    DataCell(Text(trackArtistNames?.join(', ') ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.albumName)),
                    DataCell(Text(albumName ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.albumArtistName)),
                    DataCell(Text(albumArtistName ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.trackDuration)),
                    DataCell(Text(trackDuration == null ? S.current.nA : formatDuration(Duration(milliseconds: trackDuration)))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.bitrate)),
                    DataCell(Text(bitrate?.toString() ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.mimeType)),
                    DataCell(Text(mimeType ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.filePath)),
                    DataCell(Text(song.file.path)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.year)),
                    DataCell(Text(year == null ? S.current.nA : year.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.genre)),
                    DataCell(Text(genre ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.trackNumber)),
                    DataCell(Text(trackNumber == null ? S.current.nA : trackNumber.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.diskNumber)),
                    DataCell(Text(discNumber == null ? S.current.nA : discNumber.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.authorName)),
                    DataCell(Text(authorName?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.writerName)),
                    DataCell(Text(writerName ?? S.current.nA)),
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
