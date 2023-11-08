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
  State<StatefulWidget> createState() => CurrentlyPlayingPageState();
}

class CurrentlyPlayingPageState extends State<CurrentlyPlayingPage> {
  static const String title = "Currently Playing";
  bool isLiked = false;

  late final StreamSubscription<Song?> currentlyPlayingSubscriber;

  Song? songContext;

  void _onSongChanged(Song? s) {
    if (s == null || s == songContext) {
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
    if (songContext == null) {
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
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (songContext!.metadata.albumArt != null)
            Image.memory(songContext!.metadata.albumArt!),
          if (songContext!.metadata.albumArt == null && songContext!.pictureCacheKey != null)
            FutureBuilder<File?>(
              future: ImageCacheController.getImagePathFromRaw(songContext!.pictureCacheKey!),
              builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
                return const Text('No image path found.');
              },
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              songContext!.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  // Conditional icon based on the liked state
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  // Conditional color based on the liked state
                  color: isLiked ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {

                    isLiked = !isLiked;


                    if (isLiked) {
                     logging.finest("SONG FAVOURITED");
                    } else {
                      logging.finest("SONG UNFAVOURITED");

                    }
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.playlist_add),
                onPressed: () {
                  logging.finest("ADD TO PLAYLIST");
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
                      IconButton(
                        icon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.skip_previous,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                         logging.finest("PREVIOUS SONG");
                         await AudioController.playPrevious();

                        },
                      ),
                      IconButton(
                        icon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Icon(
                              audioControllerModel.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (audioControllerModel.isPlaying) {
                            await AudioController.pause();
                          } else {
                            await AudioController.resume();
                          }
                        },
                      ),
                      IconButton(
                        icon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.stop,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          await AudioController.stop();
                        },
                      ),
                      IconButton(
                        icon: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.skip_next,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          logging.finest(" NEXT SONG");
                          await AudioController.playNext();
                        },
                      ),
                    ],
                  ),

                  TimeSlider(songDuration: songDuration, songPosition: songPosition),
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.repeat),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.speed),
                onPressed: () {
                  showDialog(context: context, builder: (ctx) => const SpeedModifierPicker());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
