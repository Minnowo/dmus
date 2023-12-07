

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
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
      body: Column(
        children: [


          Text("Entter URL Here"),
          TextField(
            controller: _controller,
            onSubmitted: (url) async {

              final streamInfo = await yt.videos.streamsClient.getManifest(url);
              videoManifest = streamInfo;
              setState(() { });
              print(streamInfo);

            },
          ),


          if(videoManifest != null && videoManifest?.streams != null)

            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    columns: const [
                      DataColumn(label: Text('DL')),
                      DataColumn(label: Text('Label')),
                      DataColumn(label: Text('Codec')),
                      DataColumn(label: Text('Container')),
                      DataColumn(label: Text('Size')),
                      DataColumn(label: Text('Bitrate')),
                    ],
                    rows: [
                      for(final i in videoManifest!.audioOnly)
                        DataRow(cells: [
                          DataCell(
                            IconButton(
                              icon: Icon(Icons.download),
                              onPressed: () => doDownload(i),
                            )
                          ),
                          DataCell(Text("${i.qualityLabel}")),
                          DataCell(Text("${i.audioCodec}")),
                          DataCell(Text("${i.container}")),
                          DataCell(Text("${i.size}")),
                          DataCell(Text("${i.bitrate}")),
                        ]),
                    ]))

        ],
      ),

    );
  }


  Future<void> doDownload(StreamInfo stream) async {

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

    logging.info("Downloging ${stream.url}");

    File savePath = File(Path.join(downloadsDirectory.path, "Video.${stream.container}"));

    var vstream = yt.videos.streamsClient.get(stream);

    var fileStream = savePath.openWrite();

    // Pipe all the content of the stream into the file.
    await vstream.pipe(fileStream);

    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    logging.info("Finished downloading");

  }
}