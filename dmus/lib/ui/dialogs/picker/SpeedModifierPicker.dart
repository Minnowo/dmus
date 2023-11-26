


import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/Util.dart';

class SpeedModifierPicker extends StatefulWidget {

  const SpeedModifierPicker({super.key});

  @override
  State<StatefulWidget> createState () => SpeedModifierPickerState();

}
class SpeedModifierPickerState extends State<SpeedModifierPicker> {

  static const double minSpeed = 1;
  static const double maxSpeed = 200;
  static final RegExp decimalMatch = RegExp(r'^([0-9]+)?\.?([0-9]+)?');

  late double progress;

  final TextEditingController _numberInputController = TextEditingController();


  String formatProgress(double progress) {
    return (progress / 100).toStringAsFixed(2);
  }

  Future<void> changePlaybackSpeedSubmit() async {

    double d = (double.tryParse(_numberInputController.text) ?? 1)
        .clamp(minSpeed / 100, maxSpeed / 100);

    await JustAudioController.instance.setPlaybackSpeed(d);

    popNavigatorSafe(context);
  }

  void cancel() {
    popNavigatorSafe(context);
  }


  @override
  void initState() {
    super.initState();

    setState(() {
      progress = JustAudioController.instance.playbackSpeed * 100;
      _numberInputController.text = formatProgress(progress);
      logging.info("Current playback speed is ${progress/100}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
                controller: _numberInputController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(decimalMatch),
                ],
                decoration: InputDecoration(
                    labelText: LocalizationMapper.current.playbackSpeed,
                    hintText: LocalizationMapper.current.playbackSpeed,
                    icon: const Icon(Icons.speed)
                )
            ),
            Slider(
              value: progress,
              min: minSpeed,
              max: maxSpeed,
              onChanged: (value) {
                setState(() {
                  progress = value.clamp(minSpeed, maxSpeed);
                  _numberInputController.text = formatProgress(progress);
                });
              },
            ),
            ListTile(
              title: Text(LocalizationMapper.current.ok),
              onTap: changePlaybackSpeedSubmit,
            ),
            ListTile(
              title: Text(LocalizationMapper.current.cancel),
              onTap: cancel,
            ),
          ]
      ),
    );
  }
}
