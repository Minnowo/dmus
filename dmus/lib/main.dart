import 'dart:async';
import 'dart:io';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/data/FileOutput.dart';
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
import 'package:fimber/fimber.dart';
import 'package:fimber_io/fimber_io.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'core/Util.dart';
import 'core/data/DataEntity.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // final dir = await getExternalStorageDirectory();

  // Fimber.plantTree(TimedRollingFileTree(
  //   filenamePrefix: '${dir?.path}/logs/',
  // ));
  Fimber.plantTree(DebugTree());



  await initLogging(Level.ALL);

  await Firebase.initializeApp();

  // AudioController.setup();

  DatabaseController.database.then((value) => logging.finest("database ready"));

  runApp(const DMUSApp());
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  static const String title = "DMUS";

  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [

      ChangeNotifierProvider<AudioControllerModel>(
          create: (_) => AudioControllerModel()
      ),

      StreamProvider<PlayerStateExtended>(
          create: (_) => JustAudioController.instance.onPlayerStateChanged,
          initialData: PlayerStateExtended(paused: false, playing: false, processingState: ProcessingState.loading)
      ),

      StreamProvider<PlayerIndex>(
          create: (_) => JustAudioController.instance.onPlayerIndexChanged,
          initialData: const PlayerIndex(index: null)
      ),

      StreamProvider<PlayerPosition>(
          create: (_) => JustAudioController.instance.onPositionChanged,
          initialData: const PlayerPosition(position: Duration.zero, duration: null)
      ),

      StreamProvider<PlayerDuration>(
          create: (_) => JustAudioController.instance.onDurationChanged,
          initialData: const PlayerDuration(position: Duration.zero, duration: null)
      ),

      StreamProvider<PlayerPlaying>(
          create: (_) => JustAudioController.instance.onPlayingChanged,
          initialData: const PlayerPlaying(playing: false)
      )

    ],
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

class RootPage extends StatefulWidget{
  const RootPage({super.key, required this.title});

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}


class _RootPageState extends State<RootPage> with WidgetsBindingObserver {

  late final List<StreamSubscription> _subscriptions;

  final List<NavigationPage> _pages = [
    const SongsPage(),
    const PlaylistsPage(),
    const AlbumsPage(),
  ];

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));

    JustAudioController.instance.init();

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

    WidgetsBinding.instance.removeObserver(this);

    JustAudioController.instance.dispose();

    for(var i in _subscriptions) {
      i.cancel();
    }
    super.dispose();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      JustAudioController.instance.stop();
    }
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
          Consumer<PlayerStateExtended>(
              builder: (context, playerState, child) {

                logging.info(playerState);

                if(playerState.paused || playerState.playing) {
                  return const CurrentlyPlayingBar();
                }

                return Container();
              })
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        destinations: _pages .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.title)).toList(),
        onDestinationSelected: navigatePage,
      ),
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


}
