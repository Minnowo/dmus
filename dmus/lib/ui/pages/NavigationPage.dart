import 'package:flutter/cupertino.dart';

abstract class NavigationPage extends Widget {
  final String title;
  final IconData icon;

  const NavigationPage({super.key, required this.title, required this.icon});
}

abstract class StatelessNavigationPage extends StatelessWidget implements NavigationPage {
  @override
  final String title;
  @override
  final IconData icon;

  const StatelessNavigationPage({super.key, required this.title, required this.icon}) : super();
}

abstract class StatefulNavigationPage extends StatefulWidget implements NavigationPage {
  @override
  final String title;
  @override
  final IconData icon;

  const StatefulNavigationPage({super.key, required this.title, required this.icon}) : super();
}
