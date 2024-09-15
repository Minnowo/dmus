
import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/ui/dialogs/context/MetadataContextDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/generated/l10n.dart';

// class EditMetadataPage extends StatefulWidget {
//
//   final DataEntity entity;
//
//   const EditMetadataPage({super.key, required this.entity});
//
//   @override
  // State<StatefulWidget> createState () => _EditMetadataPageState();
//
//
// }
// class _EditMetadataPageState extends  State<EditMetadataPage> {
//
//   final TextEditingController _trackNameController = TextEditingController();
//   final TextEditingController _albumNameController = TextEditingController();
//   final TextEditingController _trackArtistNameController = TextEditingController();
//   final TextEditingController _albumArtistNameController = TextEditingController();
//   final TextEditingController _genreController = TextEditingController();
//   final TextEditingController _authorNameController = TextEditingController();
//   final TextEditingController _writerNameController = TextEditingController();
//   final TextEditingController _trackNumberController = TextEditingController();
//   final TextEditingController _diskNumberController = TextEditingController();
//
//   static final RegExp numberOnly = RegExp(r'^[0-9]+$');
//
//   @override
//   void initState() {
//     super.initState();
//
//     setTextFromMetadata();
//   }
//
//   void setTextFromMetadata(){
//
//     switch(widget.entity.entityType) {
//       case EntityType.playlist:
//         break;
//       case EntityType.album:
//         break;
//       case EntityType.song:
//
//         Song song = (widget.entity as Song);
//         AudioMetadata metadata = song.metadata;
//
//         _trackNameController.text = metadata.title ?? song.title;
//         _albumNameController.text = metadata.album ?? "";
//         // _trackArtistNameController.text = metadata.trackArtistNames?.join(", ") ?? "";
//         // _albumArtistNameController.text = metadata.albumArtistName ?? "";
//         // _genreController.text = metadata.genre ?? "";
//         // _authorNameController.text = metadata.authorName ?? "";
//         // _writerNameController.text = metadata.writerName ?? "";
//         _trackNumberController.text = metadata.trackNumber?.toString() ?? "";
//         _diskNumberController.text = metadata.discNumber?.toString() ?? "";
//     }
//   }
//
//   Widget buildSongMetadataPage(BuildContext context) {
//
//     Song song = (widget.entity as Song);
//     AudioMetadata metadata = song.metadata;
//
//     int? year = metadata.year;
//     String? mimeType = metadata.mimeType;
//     int? trackDuration =metadata.trackDuration;
//     int? bitrate = metadata.bitrate;
//
//     Uint8List? art = metadata.albumArt;
//
//
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(S.current.editMetadata),
//         ),
//         body: ListView(
//           children: [
//
//             if(art != null)
//               Image.memory(art),
//
//             if(art == null && song.pictureCacheKey != null)
//               FutureBuilder<File?>(
//                 future: ImageCacheController.getImagePathFromRaw(song.pictureCacheKey!),
//                 builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
//
//                   if (snapshot.connectionState != ConnectionState.done ) {
//                     return const CircularProgressIndicator();
//                   }
//
//                   if (snapshot.hasError) {
//                     return Text('${S.current.errorShort} ${snapshot.error}');
//                   }
//
//                   if(!snapshot.hasData) {
//                     return const CircularProgressIndicator();
//                   }
//
//                   if (snapshot.data != null) {
//                     return Image.file(snapshot.data!, fit: BoxFit.cover, );
//                   }
//
//                   return Text(S.current.noImagePath);
//                 },
//               ),
//
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: [
//                   DataColumn(label: Text(S.current.property)),
//                   DataColumn(label: Text(S.current.value)),
//                 ],
//                 rows: [
//                   DataRow(cells: [
//                     DataCell(Text(S.current.trackName)),
//                     DataCell(
//                       TextField(
//                         controller: _trackNameController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.trackArtistNames)),
//                     DataCell(
//                       TextField(
//                         controller: _trackArtistNameController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.albumName)),
//                     DataCell(
//                       TextField(
//                         controller: _albumNameController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.albumArtistName)),
//                     DataCell(
//                       TextField(
//                         controller: _albumArtistNameController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.trackDuration)),
//                     DataCell(Text(trackDuration == null ? S.current.nA : formatDuration(Duration(milliseconds: trackDuration)))),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.bitrate)),
//                     DataCell(Text(bitrate?.toString() ?? S.current.nA)),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.mimeType)),
//                     DataCell(Text(mimeType ?? S.current.nA)),
//                   ]),
//                   DataRow(cells: [
//                     const DataCell(Text('Year')),
//                     DataCell(Text(year == null ? S.current.nA : year.toString())),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.genre)),
//                     DataCell(
//                       TextField(
//                         controller: _genreController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.trackNumber)),
//                     DataCell(
//                       TextFormField(
//                           controller: _trackNumberController,
//                           keyboardType: TextInputType.number,
//                           inputFormatters: <TextInputFormatter>[
//                             FilteringTextInputFormatter.allow(numberOnly),
//                           ],
//                       ),
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.diskNumber)),
//                     DataCell(
//                       TextFormField(
//                         controller: _diskNumberController,
//                         keyboardType: TextInputType.number,
//                         inputFormatters: <TextInputFormatter>[
//                           FilteringTextInputFormatter.allow(numberOnly),
//                         ],
//                       ),
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.authorName)),
//                     DataCell(
//                       TextField(
//                         controller: _authorNameController,
//                       )
//                     ),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text(S.current.writerName)),
//                     DataCell(
//                       TextField(
//                         controller: _writerNameController,
//                       )
//                     ),
//                   ]),
//                 ],
//               ),
//             ),
//           ],
//         )
//     );
//   }
//
//
//   Widget buildPlaylistMetadataPage(BuildContext context) {
//     return Container();
//   }
//
//   Widget buildAlbumMetadataPage(BuildContext context) {
//     return Container();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     switch(widget.entity.entityType) {
//       case EntityType.playlist:
//         return buildPlaylistMetadataPage(context);
//       case EntityType.album:
//         return buildAlbumMetadataPage(context);
//       case EntityType.song:
//         return buildSongMetadataPage(context);
//     }
//   }
// }
