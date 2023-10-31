


import 'dart:io';

import 'package:dmus/core/localstorage/ImageCacheController.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';

class CurrentlyPlayingPage extends StatelessWidget {
  const CurrentlyPlayingPage({super.key});




  @override
  Widget build(BuildContext context) {


    AudioControllerModel audioControllerModel = context.watch<AudioControllerModel>();

    if(audioControllerModel.currentlyPlaying == null) {
      return Container();
    }

    logging.info(audioControllerModel.currentlyPlaying!.metadata);

    return Scaffold(
      appBar: AppBar(
        title: Text('Currently Playing'),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cover Art
          if(audioControllerModel.currentlyPlaying?.pictureCacheKey != null)
            FutureBuilder<File?>(
              future: ImageCacheController.getImagePathFromRaw(audioControllerModel.currentlyPlaying!.pictureCacheKey!),
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

          // Song Title
          const Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Song Title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite_border),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.playlist_add),
                onPressed: () {
                },
              ),
            ],
          ),

          Visibility(
            visible: !audioControllerModel.isPlaying,
            child: IconButton(
              icon: const Icon(Icons.play_arrow), // Play button
              onPressed: () async { await AudioController.resume(); },
            ),
          ),
          Visibility(
            visible: audioControllerModel.isPlaying,
            child: IconButton(
              icon: const Icon(Icons.pause), // Pause button
              onPressed: () async { await AudioController.pause(); },
            ),
          ),

          Slider(
            value: 0.5,
            onChanged: (value) {
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.shuffle),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.repeat),
                onPressed: () {
                },
              ),
              IconButton(
                icon: Icon(Icons.speed),
                onPressed: () {
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

