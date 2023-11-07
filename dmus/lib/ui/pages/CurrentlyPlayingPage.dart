
import 'dart:async';
import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/ui/dialogs/picker/SpeedModifierPicker.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:dmus/ui/widgets/TimeSlider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';
import '../../core/data/DataEntity.dart';


class CurrentlyPlayingPage extends StatefulWidget {
  const CurrentlyPlayingPage({super.key});

  @override
  State<StatefulWidget> createState () => CurrentlyPlayingPageState();
}


class CurrentlyPlayingPageState extends State<CurrentlyPlayingPage> {

  static const String title = "Currently Playing";

  late final StreamSubscription<Song?> currentlyPlayingSubscriber;

  Song? songContext;



  void _onSongChanged(Song? s) {

    if(s == null || s == songContext) {
      return;
    }

    setState(() {
      songContext = s;
    });
  }


  @override
  void initState() {
    super.initState();

    currentlyPlayingSubscriber = AudioController.onSongChanged.listen(_onSongChanged);

    setState(() {
      songContext = context.read<AudioControllerModel>().currentlyPlaying;
    });
  }


  @override
  void dispose() {
    currentlyPlayingSubscriber.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if(songContext == null) {
      return const CircularProgressIndicator();
    }

    logging.info("Currently playing page now showing $songContext");

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          if(songContext!.metadata.albumArt != null)
            Image.memory(songContext!.metadata.albumArt!),

          if(songContext!.metadata.albumArt == null && songContext!.pictureCacheKey != null)
            FutureBuilder<File?>(
              future: ImageCacheController.getImagePathFromRaw(songContext!.pictureCacheKey!),
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

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text( songContext!.title ,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(Icons.playlist_add),
                onPressed: () {
                },
              ),
            ],
          ),

          Consumer<AudioControllerModel>(
            builder: (context, audioControllerModel, child) {

              final songDuration = audioControllerModel.duration;
              final songPosition = audioControllerModel.position;

              return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(!audioControllerModel.isPlaying)
                          IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async { await AudioController.resume(); },
                          ),

                        if(audioControllerModel.isPlaying)
                          IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: () async { await AudioController.pause(); },
                          ),
                        IconButton(
                          icon: const Icon(Icons.stop),
                            onPressed: () async { await AudioController.stop(); },
                        ),
                      ],
                    ),

                    TimeSlider(songDuration: songDuration, songPosition: songPosition)
                  ]
              );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(Icons.repeat),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(Icons.speed),
                onPressed: () {
                  showDialog(context: context, builder: (ctx) => const SpeedModifierPicker()) ;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}