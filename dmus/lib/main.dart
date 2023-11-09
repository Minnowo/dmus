import 'dart:async';

import 'package:dmus/core/audio/AudioController.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/model/AudioControllerModel.dart';
import 'package:dmus/ui/pages/AlbumsPage.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:dmus/ui/pages/PlayListsPage.dart';
import 'package:dmus/ui/pages/SongsPage.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/Util.dart';
import 'core/data/DataEntity.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
  });

  AudioController.setup();

  DatabaseController.database.then((value) => logging.finest("database ready"));

  runApp(const DMUSApp());
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  static const String title = "DMUS";

  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => AudioControllerModel(),
        child: MaterialApp(
          title: title,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const RootPage(title: title),
        )
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.title});

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}


class _RootPageState extends State<RootPage> {

  late final List<StreamSubscription> _subscriptions;

  final List<NavigationPage> _pages = [
    const SongsPage(),
    const PlaylistsPage(),
    const AlbumsPage(),
  ];

  int _currentPage = 0;


  void _onPlaylistUpdated(Playlist playlist) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Updated playlist: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onPlaylistCreated(Playlist playlist) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Created playlist: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onSongImported(Song s) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Song imported: ${s.title}", veryFastSnackBarDuration));
  }
  void _onSomethingWentWrong(String s) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Something went wrong! $s", longSnackBarDuration));
  }
  void _onShowSnackBar(SnackBarData s) {
    ScaffoldMessenger.of(context).showSnackBar(createSnackBar(s));
  }
  void _onRawException(Exception e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(createSnackBar(
        SnackBarData(text: "${e.runtimeType}: $e}", color: Colors.red)));
  }

  void navigatePage(int page) {

    if(page < 0 || page >= _pages.length || page == _currentPage) {
      return;
    }

    setState(() => _currentPage = page);
  }

  @override
  void initState() {
    super.initState();

    _subscriptions = [
      ImportController.onPlaylistCreated.listen(_onPlaylistCreated),
      ImportController.onPlaylistUpdated.listen(_onPlaylistUpdated),
      ImportController.onSongImported.listen(_onSongImported),
      MessagePublisher.onSomethingWentWrong.listen(_onSomethingWentWrong),
      MessagePublisher.onRawError.listen(_onRawException),
      MessagePublisher.onShowSnackbar.listen(_onShowSnackBar)
    ];
  }

  @override
  void dispose() {

    for(var i in _subscriptions) {
      i.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: IndexedStack(
                index: _currentPage,
                children: _pages,
              )
          ),
          const CurrentlyPlayingBar(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        destinations: _pages .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.title)).toList(),
        onDestinationSelected: navigatePage,
      ),
    );
  }
}
