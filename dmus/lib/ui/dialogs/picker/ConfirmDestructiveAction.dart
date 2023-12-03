import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
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
    this.yesTextColor,
    this.noTextColor,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              Text(
                promptText,
                textAlign: TextAlign.center,
                style: TEXT_SUBTITLE,
              ),

              const SizedBox(height: 8),

              ListTile(
                onTap: () => _onYesPressed(context),
                title: Text(yesText,
                  style: TextStyle(color: yesTextColor),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 8),

              ListTile(
                onTap: () => _onNoPressed(context),
                title: Text(noText,
                  style: TextStyle(color: noTextColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
