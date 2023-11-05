


import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';

class PlaybackSpeedSlider extends StatefulWidget {

  final double speed;

  final ValueChanged<double> onChanged;

  const PlaybackSpeedSlider({super.key, required this.speed, required this.onChanged});

  @override
  State<StatefulWidget> createState() => PlaybackSpeedSliderState();
}

class PlaybackSpeedSliderState extends State<PlaybackSpeedSlider> {

  late double progress;

  static const double minSpeed = 1;
  static const double maxSpeed = 200;

  @override
  void initState() {
    super.initState();

    setState(() {
      progress = (widget.speed * 100).clamp(minSpeed, maxSpeed);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Text("x${(progress / 100).toStringAsFixed(2)}"),
        Slider(
          value: progress,
          min: minSpeed,
          max: maxSpeed,
          onChanged: (value) {
            setState(() {
              progress = value.clamp(minSpeed, maxSpeed);
              widget.onChanged.call(progress / 100);
            });
          },
        ),
      ],
    );
  }
}
