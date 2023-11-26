import 'package:dmus/ui/Util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDestructiveAction extends StatelessWidget {
  final String promptText;
  final String yesText;
  final String noText;
  final Color? yesTextColor;
  final Color? noTextColor;

  const ConfirmDestructiveAction({
    Key? key,
    required this.promptText,
    required this.yesText,
    required this.noText,
    required this.yesTextColor,
    required this.noTextColor,
  }) : super(key: key);

  void _onYesPressed(BuildContext context) {
    popNavigatorSafeWithArgs(context, true);
  }

  void _onNoPressed(BuildContext context) {
    popNavigatorSafeWithArgs(context, false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(promptText),
          const SizedBox(height: 20),
          Column(
            children: [
              ElevatedButton(
                onPressed: () => _onYesPressed(context),

                child: Text(yesText,
                    style: TextStyle(color: yesTextColor)),

              ),
              SizedBox(height: 8), // Adjust spacing between buttons
              ElevatedButton(
                onPressed: () => _onNoPressed(context),
                style: ButtonStyle(
                  foregroundColor: MaterialStateColor.resolveWith((states) => noTextColor ?? Colors.black),
                ),
                child: Text(noText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
