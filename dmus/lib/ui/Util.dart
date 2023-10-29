


import 'package:flutter/cupertino.dart';

void popNavigatorSafe(BuildContext context) {
  if(context.mounted) {
    Navigator.pop(context);
  }
}