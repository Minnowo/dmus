

import 'package:dmus/core/data/DataEntity.dart';
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

SnackBar createSnackBar(SnackBarData data) {

  final snackBar = SnackBar(
    content: Text(data.text),
    duration: data.duration ?? const Duration(seconds: 4),
    backgroundColor: data.color,
  );

  return snackBar;
}
