

import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDestructiveAction extends StatelessWidget {

  final String promptText;
  final String yesText;
  final String noText;
  final Color? yesTextColor;
  final Color? noTextColor;

  const ConfirmDestructiveAction({super.key, required this.promptText, required this.yesText, required this.noText,required this.yesTextColor, required this.noTextColor});

  void _onYesPressed(BuildContext context){
    popNavigatorSafeWithArgs(context, true);
  }

  void _onNoPressed(BuildContext context){
    popNavigatorSafeWithArgs(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(promptText),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _onYesPressed(context),
                child: Text(
                  yesText,
                  style: TextStyle(color: yesTextColor),
                ),
              ),
              ElevatedButton(
                onPressed: () => _onNoPressed(context),
                child: Text(
                  noText,
                  style: TextStyle(color: noTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



}