import 'dart:io';
import 'dart:typed_data';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:dmus/core/Util.dart';
import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/FullMetadataReader.dart';
import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableFMetadata.dart';
import 'package:dmus/core/localstorage/dbimpl/TableMusicBrainz.dart';
import 'package:flutter/material.dart';

import '/generated/l10n.dart';

/// The extra metadata columns that live outside of [AudioMetadata]
class _ExtendedSongMetadata {
  final CommonExtraMetadata? extra;
  final MusicBrainzIds? musicBrainzIds;

  const _ExtendedSongMetadata({this.extra, this.musicBrainzIds});
}

class MetadataPage extends StatelessWidget {
  final DataEntity entity;

  const MetadataPage({super.key, required this.entity});

  Future<_ExtendedSongMetadata> _loadExtendedMetadata(int songId) async {
    final db = await DatabaseController.database;

    final extra = await TableFMetadata.selectExtraForSongId(db, songId);
    final musicBrainzIds = await TableMusicBrainz.selectForSongId(db, songId);

    return _ExtendedSongMetadata(extra: extra, musicBrainzIds: musicBrainzIds);
  }

  Widget buildSongMetadataPage(BuildContext context) {
    Song song = (entity as Song);
    AudioMetadata metadata = song.metadata;

    String? trackName = metadata.title ?? song.title;
    String? albumName = metadata.album;
    String? albumArtistName = metadata.artist;
    int? trackNumber = metadata.trackNumber;
    // int? albumLength = metadata.albumLength; // i have no idea what this is
    int? year = metadata.year?.year;
    String genre = metadata.genres.join(", ");
    int? discNumber = metadata.discNumber;
    Duration? trackDuration = metadata.duration;
    int? bitrate = metadata.bitrate;

    Uint8List? art;

    if (metadata.pictures.isNotEmpty) {
      art = metadata.pictures.first.bytes;
    }

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
            if (art != null) Image.memory(art),
            if (art == null && song.pictureCacheKey != null)
              FutureBuilder<File?>(
                future: ImageCacheController.getImagePathFromRaw(song.pictureCacheKey!),
                builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('${S.current.errorShort} ${snapshot.error}');
                  }

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.data != null) {
                    return Image.file(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    );
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
                    DataCell(Text(S.current.albumName)),
                    DataCell(Text(albumName ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.albumArtistName)),
                    DataCell(Text(albumArtistName ?? S.current.nA)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.trackDuration)),
                    DataCell(Text(trackDuration == null ? S.current.nA : formatDuration(trackDuration))),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.bitrate)),
                    DataCell(Text(bitrate?.toString() ?? S.current.nA)),
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
                    DataCell(Text(genre == "" ? S.current.nA : genre)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.trackNumber)),
                    DataCell(Text(trackNumber == null ? S.current.nA : trackNumber.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(S.current.diskNumber)),
                    DataCell(Text(discNumber == null ? S.current.nA : discNumber.toString())),
                  ]),
                ],
              ),
            ),
            FutureBuilder<_ExtendedSongMetadata>(
              future: _loadExtendedMetadata(song.id),
              builder: (BuildContext context, AsyncSnapshot<_ExtendedSongMetadata> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Text('${S.current.errorShort} ${snapshot.error}');
                }

                final extra = snapshot.data?.extra;
                final mbIds = snapshot.data?.musicBrainzIds;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: [
                          DataColumn(label: Text(S.current.property)),
                          DataColumn(label: Text(S.current.value)),
                        ],
                        rows: [
                          DataRow(cells: [
                            DataCell(Text(S.current.trackArtistName)),
                            DataCell(Text(extra?.trackArtist ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.bpm)),
                            DataCell(Text(extra?.bpm?.toString() ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.composer)),
                            DataCell(Text(extra?.composer ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.isrc)),
                            DataCell(Text(extra?.isrc ?? S.current.nA)),
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(S.current.musicBrainzInformation, style: Theme.of(context).textTheme.titleMedium),
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
                            DataCell(Text(S.current.recordingId)),
                            DataCell(Text(mbIds?.recordingId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.releaseId)),
                            DataCell(Text(mbIds?.releaseId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.releaseGroupId)),
                            DataCell(Text(mbIds?.releaseGroupId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.releaseTrackId)),
                            DataCell(Text(mbIds?.releaseTrackId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.artistId)),
                            DataCell(Text(mbIds?.artistId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.albumArtistId)),
                            DataCell(Text(mbIds?.albumArtistId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.workId)),
                            DataCell(Text(mbIds?.workId ?? S.current.nA)),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(S.current.acoustId)),
                            DataCell(Text(mbIds?.acoustId ?? S.current.nA)),
                          ]),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ));
  }

  Widget buildPlaylistMetadataPage(BuildContext context) {
    return Container();
  }

  Widget buildAlbumMetadataPage(BuildContext context) {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    switch (entity.entityType) {
      case EntityType.playlist:
        return buildPlaylistMetadataPage(context);
      case EntityType.album:
        return buildAlbumMetadataPage(context);
      case EntityType.song:
        return buildSongMetadataPage(context);
    }
  }
}
