


import 'package:dmus/core/data/DataEntity.dart';
import 'package:flutter/cupertino.dart';

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
