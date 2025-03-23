import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../localstorage/ImportController.dart';
import '../../localstorage/dbimpl/TableAlbum.dart';
import '../DataEntity.dart';

class AlbumProvider extends ChangeNotifier {
  late final List<StreamSubscription> _subscriptions;

  final List<Album> albums = [];

  AlbumProvider() {
    _subscriptions = [
      ImportController.onAlbumCacheRebuild.listen(rebuildAlbums),
    ];

    rebuildAlbums(null);
  }

  @override
  void dispose() {
    for (final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }

  /// Rebuilds the albums in the database and fills the albums again
  Future<void> rebuildAlbums(void a) async => await TableAlbum.selectAll().then(fillAlbums);

  /// Clear and fill the albums
  void fillAlbums(Iterable<Album> i) {
    albums.clear();
    albums.addAll(i);
    notifyListeners();
  }
}
