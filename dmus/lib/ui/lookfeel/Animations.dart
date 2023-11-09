


import 'package:flutter/cupertino.dart';

void animateOpenFromBottom(BuildContext context, Widget page) {

  if(!context.mounted) return;

  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (BuildContext context, animation, secondaryAnimation) => page,

      transitionsBuilder: (context, animation, secondaryAnimation, child) {

        final tween = Tween(
            begin: const Offset(0, 1),
            end: Offset.zero
        );

        return SlideTransition(
          position: tween.animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              )),
          child: child,
        );
      },
    ),
  );
}
