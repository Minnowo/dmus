import 'dart:async';
import 'dart:io';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/dbimpl/TableLikes.dart';
import 'package:dmus/generated/l10n.dart';
import 'package:dmus/l10n/LocalizationMapper.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/Theming.dart';
import 'package:dmus/ui/pages/AlbumsPage.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:dmus/ui/pages/PlayListsPage.dart';
import 'package:dmus/ui/pages/SearchPage.dart';
import 'package:dmus/ui/pages/SongsPage.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingBar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/Util.dart';
import 'core/data/DataEntity.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await initLogging(Level.ALL);

  await DatabaseController.database;

  await Firebase.initializeApp();
  
  final Locale myLocale = Locale(Platform.localeName);
  await LocalizationMapper.load(myLocale);

  runApp(const DMUSApp());
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  static const String title = "DMUS";

  @override
  Widget build(BuildContext context) {

    return MultiProvider(providers: [

      StreamProvider<PlayerSong>(
          create: (_) => JustAudioController.instance.onPlayerSongChanged,
          initialData: PlayerSong( song: null,
              playerState: PlayerStateExtended(paused: false, playing: false, processingState: ja.ProcessingState.loading),
              position: Duration.zero, duration: Duration.zero, index: 0
          ),
        lazy: false, // creates stream immediately (fixes first song = null problem)
      ),

      StreamProvider<PlayerStateExtended>(
          create: (_) => JustAudioController.instance.onPlayerStateChanged,
          initialData: PlayerStateExtended(paused: false, playing: false, processingState: ja.ProcessingState.loading)
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
          initialData: const PlayerPlaying(playing: false, song: null)
      ),

      StreamProvider<PlayerShuffleOrder>(
          create: (_) => JustAudioController.instance.onShuffleOrderChanged,
          initialData: const PlayerShuffleOrder(before: ShuffleOrder.inOrder, after: ShuffleOrder.inOrder)
      ),

      StreamProvider<PlayerRepeat>(
          create: (_) => JustAudioController.instance.onRepeatChanged,
          initialData: const PlayerRepeat(repeat: false)
      )

    ],
        child: MaterialApp(
          title: title,
          theme: darkTheme(),
          localizationsDelegates: const [
            S.delegate,
            ...GlobalMaterialLocalizations.delegates,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('fr', ''),
            Locale('sp', ''),
          ],
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
    const SearchPage(),
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

    ImportController.checkWatchFolders();
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
          const CurrentlyPlayingBar()
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
    if(ImportController.reduceSnackBars) return;
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("${LocalizationMapper.current.updatedPlaylist}: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onPlaylistCreated(Playlist playlist) {
    if(ImportController.reduceSnackBars) return;
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("${LocalizationMapper.current.createdPlaylist}: ${playlist.title}", mediumSnackBarDuration));
  }
  void _onSongImported(Song s) {
    if(ImportController.reduceSnackBars) return;
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("${LocalizationMapper.current.songImported}: ${s.title}", veryFastSnackBarDuration));
  }
  void _onSomethingWentWrong(String s) {
    ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration("${LocalizationMapper.current.error} $s", longSnackBarDuration));
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
