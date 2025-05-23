import 'package:flutter/material.dart';

class BlueDivider extends StatelessWidget {
  const BlueDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.blue,
      thickness: 2.5,
      indent: 0,
      endIndent: 250,
    );
  }
}
