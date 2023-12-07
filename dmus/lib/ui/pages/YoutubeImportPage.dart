

import 'dart:io';

import 'package:dmus/core/data/DataEntity.dart';
import 'package:dmus/core/data/FFmpegHandler.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as Path;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../core/Util.dart';
import '../../core/data/MessagePublisher.dart';

class YoutubeImportPage extends StatefulWidget {
  const YoutubeImportPage({super.key});

  @override
  State<StatefulWidget> createState() => _YoutubeImportPageState();
}


class _YoutubeImportPageState extends State<YoutubeImportPage> {

  final TextEditingController _controller = TextEditingController();
  final YoutubeExplode yt = YoutubeExplode();

  StreamManifest? videoManifest;
  Video? video;

  @override
  void dispose() {
    super.dispose();
    yt.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Youtube Download"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const Text("Enter URL Here"),
          TextField(
            controller: _controller,
            onSubmitted: getYtVideo,
          ),

          if(video != null)
            Image.network(video!.thumbnails.mediumResUrl,
                errorBuilder: (ctx, obj, stck) => Image.network(
                    video!.thumbnails.lowResUrl,
                    errorBuilder: (ctx, obj, stck) => const Text("Could not load image 404")
                )
            ),

          if(video != null)
            buildVideoWidget(video!),

          if(videoManifest != null && video != null)
            buildManifestView(video!, videoManifest!),

        ],
      ),

    );
  }

  Widget buildManifestView(Video vid, StreamManifest man) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
            columns: const [
              DataColumn(label: Text('DL')),
              DataColumn(label: Text('Codec')),
              DataColumn(label: Text('Size')),
              DataColumn(label: Text('Bitrate')),
            ],
            rows: [
              for(final i in man.audioOnly)
                DataRow(cells: [
                  DataCell(
                      IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () => doDownload(vid, i),
                      )
                  ),
                  DataCell(Text(i.audioCodec)),
                  DataCell(Text("${i.size}")),
                  DataCell(Text("${i.bitrate}")),
                ]),
            ])
    );
  }

  Widget buildVideoWidget(Video v) {
    return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              columns: const [
                DataColumn(label: Text('Property')),
                DataColumn(label: Text('Value')),
              ],
              rows: [
                  DataRow(cells: [
                    const DataCell(Text("ID")),
                    DataCell(Text(v.id.toString())),
                  ]),
                DataRow(cells: [
                  const DataCell(Text("Title")),
                  DataCell(Text(v.title)),
                ]),
                DataRow(cells: [
                  const DataCell(Text("Author")),
                  DataCell(Text(v.author)),
                ]),
                DataRow(cells: [
                  const DataCell(Text("Duration")),
                  DataCell(Text(formatDuration(v.duration ?? Duration.zero))),
                ]),
              ]))
;
  }


  Future<void> getYtVideo(String url) async {
    video = await yt.videos.get(url);
    videoManifest = await yt.videos.streamsClient.getManifest(url);

    logging.info("Got video $video");
    logging.info("Got streams $videoManifest");
    logging.info("Thumbnails ${video?.thumbnails.highResUrl}");

    setState(() { });
  }

  Future<void> doDownload(Video vid, StreamInfo stream) async {

    bool _ = await getExternalStoragePermission();

    final String? downloadsPath = await getDownloadPath();

    if (downloadsPath == null) {
      logging.info("No download path!");
      return;
    }

    final downloadsDirectory = Directory(Path.join(downloadsPath, "dmus", "yt"));

    try{
      await downloadsDirectory.create(recursive: true);
    }
    on OSError catch(e) {
      logging.info("Could not create $downloadsDirectory");
      return;
    }

    if(!await downloadsDirectory.exists()) {
      logging.info("$downloadsDirectory does not exist");
      return;
    }


    logging.info("Downloading ${stream.url}");

    File savePath = File(Path.join(downloadsDirectory.path, "Video.raw"));
    File finalPath = File(Path.join(downloadsDirectory.path, "${vid.id}.mp3"));
    File thumbPath = File(Path.join(downloadsDirectory.path, "${vid.id}.jpg"));

    logging.info("Codec is ${stream.codec.mimeType} mime, ${stream.codec.subtype} subtype, ${stream.codec.type} type, ${stream.codec.parameters}");

    try {
      final vstream = yt.videos.streamsClient.get(stream);
      final fileStream = savePath.openWrite();
      await vstream.pipe(fileStream);
      await fileStream.flush();
      await fileStream.close();
    }
    catch(e) {
      logging.warning(e);
      MessagePublisher.publishSomethingWentWrong("Error while downloading stream: $e");
      return;
    }

    bool useThumb = await downloadThumbToPath(vid.thumbnails, thumbPath);

    logging.info("About to convert $savePath to $finalPath with ffmpeg");

    bool ffmpegGood = await FFmpegHandler.encodeVideoAudioToFileAsMp3(
        savePath,
        finalPath,
        vid.title,
        vid.author,
        vid.description,
        thumb: useThumb ? thumbPath : null
    );

    if(ffmpegGood) {
      await ImportController.importSong(finalPath);
    } else {
      MessagePublisher.publishSnackbar(const SnackBarData(text: "There was an error encoding the stream!"));
    }

    try{
      await savePath.delete();
    } catch(e) {
      // ignore failed to delete
    }

    logging.info("Finished downloading");
  }


  Future<bool> downloadThumbToPath(ThumbnailSet t, File path) async {

    final order = [
      t.highResUrl,
      t.maxResUrl,
      t.standardResUrl,
      t.mediumResUrl,
      t.lowResUrl
    ];

    for(final url in order) {

      try {

        logging.info("Trying to download thumb $url");

        final response = await http.get(Uri.parse(url));
        await path.writeAsBytes(response.bodyBytes);

        return true;
      }
      catch(e) {
        logging.warning("Could not download thumbnail $url: $e");
      }
    }

    MessagePublisher.publishSnackbar(const SnackBarData(text: "Could not find thumbnail for stream"));

    return false;
  }
}