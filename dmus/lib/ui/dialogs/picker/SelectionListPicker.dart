import 'package:flutter/cupertino.dart';

import '../../../core/data/DataEntity.dart';
import '../../Util.dart';

mixin class SelectionListPicker<T> {
  final List<SelectableDataItem<T>> items = [];

  void clearFilter() {
    showAllItems();
  }

  void filterItems(String text, bool Function(String, T) matcher) {
    if (text.isEmpty) {
      showAllItems();
      return;
    }

    for (final s in text.toLowerCase().split("\s+")) {
      for (final i in items) {
        i.isVisible = matcher(s, i.item);
      }
    }
  }

  void finishSelection(BuildContext context) {
    popNavigatorSafeWithArgs<Iterable<T>>(context, items.where((element) => element.isSelected).map((e) => e.item));
  }

  void selectAllItems() {
    setAllItemsSelection(true);
  }

  void deselectAllItems() {
    setAllItemsSelection(false);
  }

  void setAllItemsSelection(bool isSelected) {
    for (var e in items) {
      e.isSelected = isSelected;
    }
  }

  void showAllItems() {
    setAllItemsVisibility(true);
  }

  void hideAllItems() {
    setAllItemsSelection(false);
  }

  void setAllItemsVisibility(bool isVisible) {
    for (var e in items) {
      e.isVisible = isVisible;
    }
  }
}
