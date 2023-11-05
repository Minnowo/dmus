

import 'package:flutter/material.dart';

void popNavigatorSafe(BuildContext context) {
  if(context.mounted) {
    Navigator.pop(context);
  }
}

void popNavigatorSafeWithArgs<T extends Object>(BuildContext context, [T? result]) {
  if(context.mounted) {
    Navigator.pop(context, result);
  }
}

SnackBar createSimpleSnackBar(String text) {

  final snackBar = SnackBar( content: Text(text),);

  return snackBar;
}

SnackBar createSimpleSnackBarWithDuration(String text, Duration d) {

  final snackBar = SnackBar( content: Text(text), duration: d,);

  return snackBar;
}
