
import 'dart:io';
import 'dart:typed_data';

import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/ui/dialogs/context/MetadataContextDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class EditMetadataPage extends StatefulWidget {

  final DataEntity entity;

  const EditMetadataPage({super.key, required this.entity});

  @override
  State<StatefulWidget> createState () => _EditMetadataPageState();


}
class _EditMetadataPageState extends  State<EditMetadataPage> {

  final TextEditingController _trackNameController = TextEditingController();
  final TextEditingController _albumNameController = TextEditingController();
  final TextEditingController _trackArtistNameController = TextEditingController();
  final TextEditingController _albumArtistNameController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _writerNameController = TextEditingController();
  final TextEditingController _trackNumberController = TextEditingController();
  final TextEditingController _diskNumberController = TextEditingController();

  static final RegExp numberOnly = RegExp(r'^[0-9]+$');

  @override
  void initState() {
    super.initState();

    setTextFromMetadata();
  }

  void setTextFromMetadata(){

    switch(widget.entity.entityType) {
      case EntityType.playlist:
        break;
      case EntityType.album:
        break;
      case EntityType.song:

        Song song = (widget.entity as Song);
        Metadata metadata = song.metadata;

        _trackNameController.text = metadata.trackName ?? song.title;
        _albumNameController.text = metadata.albumName ?? "";
        _trackArtistNameController.text = metadata.trackArtistNames?.join(", ") ?? "";
        _albumArtistNameController.text = metadata.albumArtistName ?? "";
        _genreController.text = metadata.genre ?? "";
        _authorNameController.text = metadata.authorName ?? "";
        _writerNameController.text = metadata.writerName ?? "";
        _trackNumberController.text = metadata.trackNumber?.toString() ?? "";
        _diskNumberController.text = metadata.discNumber?.toString() ?? "";
    }
  }

  Widget buildSongMetadataPage(BuildContext context) {

    Song song = (widget.entity as Song);
    Metadata metadata = song.metadata;

    int? year = metadata.year;
    String? mimeType = metadata.mimeType;
    int? trackDuration =metadata.trackDuration;
    int? bitrate = metadata.bitrate;

    Uint8List? art = metadata.albumArt;


    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Metadata'),
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
                    DataCell(
                      TextField(
                        controller: _trackNameController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Track Artist Names')),
                    DataCell(
                      TextField(
                        controller: _trackArtistNameController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Album Name')),
                    DataCell(
                      TextField(
                        controller: _albumNameController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Album Artist Name')),
                    DataCell(
                      TextField(
                        controller: _albumArtistNameController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Track Duration')),
                    DataCell(Text(trackDuration == null ? "N/A" : formatDuration(Duration(milliseconds: trackDuration)))),
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
                    DataCell(
                      TextField(
                        controller: _genreController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Track Number')),
                    DataCell(
                      TextFormField(
                          controller: _trackNumberController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(numberOnly),
                          ],
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Disk Number')),
                    DataCell(
                      TextFormField(
                        controller: _diskNumberController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(numberOnly),
                        ],
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Author Name')),
                    DataCell(
                      TextField(
                        controller: _authorNameController,
                      )
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Writer Name')),
                    DataCell(
                      TextField(
                        controller: _writerNameController,
                      )
                    ),
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

    switch(widget.entity.entityType) {
      case EntityType.playlist:
        return buildPlaylistMetadataPage(context);
      case EntityType.album:
        return buildAlbumMetadataPage(context);
      case EntityType.song:
        return buildSongMetadataPage(context);
    }
  }
}
