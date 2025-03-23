

import 'dart:async';

import 'package:flutter/cupertino.dart';

import '../../Util.dart';
import '../../localstorage/ImportController.dart';
import '../../localstorage/dbimpl/TableArtist.dart';
import '../DataEntity.dart';

class ArtistProvider extends ChangeNotifier {

  late final List<StreamSubscription> _subscriptions;

  final List<Album> albums = [];

  ArtistProvider() {

    _subscriptions = [
      ImportController.onArtistCacheRebuild.listen(rebuildAlbums),
    ];

    rebuildAlbums(null);
  }

  @override
  void dispose() {

    for(final i in _subscriptions) {
      i.cancel();
    }

    super.dispose();
  }

  Future<void> rebuildAlbums(void a) async => await TableArtist.selectAll().then(fillAlbums);

  void fillAlbums(Iterable<Album> i) {

    albums.clear();
    albums.addAll(i);
    notifyListeners();
  }
}