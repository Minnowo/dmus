


import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/widgets/PlaybackSpeedSlider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/Util.dart';

class SpeedModifierPicker extends StatefulWidget {

  const SpeedModifierPicker({super.key});

  @override
  State<StatefulWidget> createState () => SpeedModifierPickerState();

}
class SpeedModifierPickerState extends State<SpeedModifierPicker> {

  double speed = 1;

  @override
  void initState() {
    super.initState();

    setState(() {
      speed = AudioController.playbackSpeed;
      logging.info("Current playback speed is $speed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlaybackSpeedSlider(
                onChanged: (speed) {
                  setState(() {
                    this.speed = speed;
                  });
                },
                speed: speed),
            ListTile(
              title: const Text('Ok'),
              onTap: () async {

                logging.info("Setting playback speed to $speed");
                await AudioController.setPlaybackSpeed(speed);

                popNavigatorSafe(context);
              },
            ),
            ListTile(
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ]
      ),
    );
  }
}
