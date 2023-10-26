import 'package:dmus/ui/pages/AlbumsPage.dart';
import 'package:dmus/ui/pages/NavigationPage.dart';
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

class PageNavItem{
  final String title;
  final Icon icon;
  final Widget page;

  const PageNavItem({required this.title, required this.icon,required this.page});
}

class _RootPageState extends State<RootPage> {

  PageController _pageController = PageController();
  int _currentPage = 0;

  final List<NavigationPage> _pages = [
    const SongsPage(),
    const PlaylistsPage(),
    const AlbumsPage(),
  ];

  void navigatePage(int page) {

    if(page < 0 || page >= _pages.length || page == _currentPage)
      return;

    setState(() => _currentPage = page);

    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: PageView(
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: _pages
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex:_currentPage,
        destinations: _pages .map((e) => NavigationDestination(icon: Icon(e.icon), label: e.title)).toList(),
        onDestinationSelected: navigatePage,
      ),
    );
  }
}
