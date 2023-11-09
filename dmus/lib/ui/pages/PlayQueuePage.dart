

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlayQueuePage extends StatelessWidget {
  const PlayQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.all(5),
            child: SizedBox(
              width: 56.0,
              child: IconButton(
                icon: const Icon(Icons.expand_more_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          leadingWidth: 56,
          toolbarHeight: 80.0,
        ));
  }
}