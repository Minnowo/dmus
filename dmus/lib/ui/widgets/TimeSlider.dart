


import 'package:flutter/material.dart';

import '../../core/Util.dart';
import '../../core/audio/AudioController.dart';

class TimeSlider extends StatefulWidget {

  final Duration songDuration ;

  final Duration songPosition;

  const TimeSlider({super.key, required this.songDuration, required this.songPosition});

  @override
  State<StatefulWidget> createState() => TimeSliderState();

}

class TimeSliderState extends State<TimeSlider> {

  double progress = 0;

  late Duration songPosition;

  @override
  void initState() {
    super.initState();

    setState(() {
      songPosition = widget.songPosition;
    });
  }

  bool isDragging = false;

  @override
  Widget build(BuildContext context) {

    if(!isDragging && widget.songDuration.inMilliseconds != 0) {
      progress = (widget.songPosition.inMilliseconds.toDouble() / widget.songDuration.inMilliseconds).clamp(0, 1);
    }

    final sp = Duration(milliseconds: (widget.songDuration.inMilliseconds.toDouble() * progress).toInt());

    return Column(
      children: [
        Slider(
          value: progress,
          onChanged: (value) {
            setState(() {
              progress = value.clamp(0, 1);
            });
          },
          onChangeStart: (value) async {
            isDragging = true;
            // await AudioController.pause();
          },
          onChangeEnd: (value) async {
            isDragging = false;

            // await JustAudioController.instance.seekToPosition(sp);
            // await AudioController.resumePlayLast();
          },
        ),

        Text(formatTimeDisplay(sp, widget.songDuration)),
      ],
    );
  }
}