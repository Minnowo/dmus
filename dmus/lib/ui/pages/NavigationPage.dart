
import 'package:flutter/cupertino.dart';

abstract class NavigationPage extends StatefulWidget {

  final String title;
  final IconData icon;

  const NavigationPage({super.key, required this.title, required this.icon});
}
