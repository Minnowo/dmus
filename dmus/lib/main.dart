import 'package:dmus/ui/pages/AlbumsPage.dart';
import 'package:dmus/ui/pages/PlayListsPage.dart';
import 'package:dmus/ui/pages/SongsPage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DMUSApp());
}

class DMUSApp extends StatelessWidget {
  const DMUSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RootPage(title: 'Flutter Demo Home Page'),
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

  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _pages = <Widget>[
    const SongsPage(),
    const PlaylistsPage(),
    const AlbumsPage(),
  ];

  void _changePage(int page) {
    _pageController.animateToPage(
      page,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: _pages
            );
  }
}
