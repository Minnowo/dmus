import 'dart:async';
import 'dart:io';

import 'package:dmus/core/audio/AudioController.dart';
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
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'core/Util.dart';
import 'core/data/DataEntity.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(); // Initialize Firebase


  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(const DMUSApp());
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  @override
  Widget build(BuildContext context) {

    AudioController.setup();
    DatabaseController.database.then((value) => logging.finest("database ready"));

    return ChangeNotifierProvider(
        create: (context) => AudioControllerModel(),
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const RootPage(title: 'Flutter Demo Home Page'),
        ));
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.title});

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}


class _RootPageState extends State<RootPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final List<StreamSubscription> _subscriptions;

  final List<NavigationPage> _pages = [
    const SongsPage(),
    const PlaylistsPage(),
    const AlbumsPage(),
  ];

  void navigatePage(int page) {

    if(page < 0 || page >= _pages.length || page == _currentPage) {
      return;
    }

    setState(() => _currentPage = page);

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  void _onPlaylistUpdated(Playlist playlist) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Updated playlist: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onPlaylistCreated(Playlist playlist) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Created playlist: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onSongImported(Song s) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("Song imported: ${s.title}", veryFastSnackBarDuration));
  }

  @override
  void initState() {
    super.initState();

    _subscriptions = [
      ImportController.onPlaylistCreated.listen(_onPlaylistCreated),
      ImportController.onPlaylistUpdated.listen(_onPlaylistUpdated),
      ImportController.onSongImported.listen(_onSongImported)
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
              child: PageView(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: _pages
              )
          ),
          const CurrentlyPlayingBar(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex:_currentPage,
        destinations: _pages .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.title)).toList(),
        onDestinationSelected: navigatePage,
      ),
    );
  }
}
