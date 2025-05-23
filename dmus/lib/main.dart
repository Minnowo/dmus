import 'dart:async';

import 'package:dmus/core/audio/JustAudioController.dart';
import 'package:dmus/core/audio/ProviderData.dart';
import 'package:dmus/core/data/MessagePublisher.dart';
import 'package:dmus/core/data/provider/AlbumProvider.dart';
import 'package:dmus/core/data/provider/ArtistProvider.dart';
import 'package:dmus/core/data/provider/PlaylistProvider.dart';
import 'package:dmus/core/data/provider/SongsProvider.dart';
import 'package:dmus/core/data/provider/ThemeProvider.dart';
import 'package:dmus/core/localstorage/DatabaseController.dart';
import 'package:dmus/core/localstorage/ImportController.dart';
import 'package:dmus/core/localstorage/SettingsHandler.dart';
import 'package:dmus/generated/l10n.dart';
import 'package:dmus/ui/Settings.dart';
import 'package:dmus/ui/Util.dart';
import 'package:dmus/ui/lookfeel/CommonTheme.dart';
import 'package:dmus/ui/lookfeel/DarkTheme.dart';
import 'package:dmus/ui/lookfeel/LightTheme.dart';
import 'package:dmus/ui/pages/AlbumsPage.dart';
import 'package:dmus/ui/pages/ArtistPage.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
import 'package:dmus/ui/pages/PlayListsPage.dart';
import 'package:dmus/ui/pages/SearchPage.dart';
import 'package:dmus/ui/pages/SongsPage.dart';
import 'package:dmus/ui/widgets/CurrentlyPlayingBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'core/Util.dart';
import 'core/audio/PlayQueue.dart';
import 'core/data/DataEntity.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initLogging(Level.ALL);

  await DatabaseController.database;

  await SettingsHandler.load();

  await S.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Add ThemeProvider to the root of your widget tree
      child: const DMUSApp(),
    ),
  );
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  static const String title = "DMUS";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PlaylistProvider>(create: (_) => PlaylistProvider()),
        ChangeNotifierProvider<SongsProvider>(create: (_) => SongsProvider()),
        ChangeNotifierProvider<AlbumProvider>(create: (_) => AlbumProvider()),
        ChangeNotifierProvider<ArtistProvider>(create: (_) => ArtistProvider()),
        StreamProvider<PlayerSong>(
          create: (_) => JustAudioController.instance.onPlayerSongChanged,
          initialData: PlayerSong(
              song: null,
              playerState:
                  PlayerStateExtended(paused: false, playing: false, processingState: ja.ProcessingState.loading),
              position: Duration.zero,
              duration: Duration.zero,
              index: 0),
          lazy: false, // creates stream immediately (fixes first song = null problem)
        ),
        StreamProvider<QueueShuffle>(
          create: (_) => JustAudioController.instance.onQueueShuffle,
          initialData: const QueueShuffle(),
          updateShouldNotify: (a, b) => true,
        ),
        StreamProvider<QueueChanged>(
          create: (_) => JustAudioController.instance.onQueueChanged,
          initialData: const QueueChanged(
              length: 0, position: -1, lastPlaylistIsQueue: INVALID_PLAYLIST_ID, song: null, state: QueueState.empty),
        ),
        StreamProvider<PlayerStateExtended>(
            create: (_) => JustAudioController.instance.onPlayerStateChanged,
            initialData:
                PlayerStateExtended(paused: false, playing: false, processingState: ja.ProcessingState.loading)),
        StreamProvider<PlayerIndex>(
            create: (_) => JustAudioController.instance.onPlayerIndexChanged,
            initialData: const PlayerIndex(index: null)),
        StreamProvider<PlayerPosition>(
            create: (_) => JustAudioController.instance.onPositionChanged,
            initialData: const PlayerPosition(position: Duration.zero, duration: null)),
        StreamProvider<PlayerDuration>(
            create: (_) => JustAudioController.instance.onDurationChanged,
            initialData: const PlayerDuration(position: Duration.zero, duration: null)),
        StreamProvider<PlayerPlaying>(
            create: (_) => JustAudioController.instance.onPlayingChanged,
            initialData: const PlayerPlaying(playing: false, song: null)),
        StreamProvider<PlayerShuffleOrder>(
            create: (_) => JustAudioController.instance.onShuffleOrderChanged,
            initialData: const PlayerShuffleOrder(before: ShuffleOrder.inOrder, after: ShuffleOrder.inOrder)),
        StreamProvider<PlayerRepeat>(
            create: (_) => JustAudioController.instance.onRepeatChanged, initialData: const PlayerRepeat(repeat: false))
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: title,
            theme: themeProvider.isDarkModeEnabled ? darkTheme() : lightTheme(),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('en', 'US'),
            ],
            home: const RootPage(title: title),
          );
        },
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key, required this.title});

  final String title;

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> with WidgetsBindingObserver {
  late final List<StreamSubscription> _subscriptions;

  final List<NavigationPage> _pages = [
    SongsPage(),
    PlaylistsPage(),
    AlbumsPage(),
    ArtistPage(),
    SearchPage(),
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

    SettingsHandler.save();

    for (var i in _subscriptions) {
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
          )),
          const CurrentlyPlayingBar()
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPage,
        destinations: _pages.map((e) => NavigationDestination(icon: Icon(e.icon), label: e.title)).toList(),
        onDestinationSelected: navigatePage,
      ),
    );
  }

  void _onPlaylistUpdated(Playlist playlist) {
    if (ImportController.reduceSnackBars) return;
    showSnackBarWithDuration(context, "${S.current.updatedPlaylist}: ${playlist.title}", mediumSnackBarDuration);
    // ScaffoldMessenger.of(context).showSnackBar(createSimpleSnackBarWithDuration(, mediumSnackBarDuration));
  }

  void _onPlaylistCreated(Playlist playlist) {
    if (ImportController.reduceSnackBars) return;
    showSnackBarWithDuration(context, "${S.current.createdPlaylist}: ${playlist.title}", mediumSnackBarDuration);
  }

  void _onSongImported(Song s) {
    if (ImportController.reduceSnackBars) return;
    showSnackBarWithDuration(context, "${S.current.songImported}: ${s.title}", mediumSnackBarDuration);
  }

  void _onSomethingWentWrong(String s) {
    showSnackBarWithDuration(context, "${S.current.error} $s", longSnackBarDuration);
  }

  void _onShowSnackBar(SnackBarData s) {
    // ScaffoldMessenger.of(context).showSnackBar(createSnackBar(s));
    showSnackBarWithDuration(context, s.text, s.duration ?? mediumSnackBarDuration);
  }

  void _onRawException(Exception e) {
    showSnackBarWithDuration(context, "${e.runtimeType}: $e", longSnackBarDuration, color: RED);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(createSnackBar(
    //     SnackBarData(text: "${e.runtimeType}: $e}", color: Colors.red)));
  }

  void navigatePage(int page) {
    if (page < 0 || page >= _pages.length || page == _currentPage) {
      return;
    }

    setState(() => _currentPage = page);
  }
}
