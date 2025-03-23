import 'package:flutter/material.dart';

import '../../core/data/DataEntity.dart';
import '../../core/localstorage/dbimpl/TableLikes.dart';

class LikeButton extends StatefulWidget {
  final Song songContext;

  const LikeButton({super.key, required this.songContext});

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  @override
  Widget build(BuildContext context) {
    Song songContext = widget.songContext;

    return IconButton(
      icon: Icon(
        songContext.liked ? Icons.favorite : Icons.favorite_border,
        color: songContext.liked ? Colors.red : null,
      ),
      onPressed: () async {
        songContext.liked = !songContext.liked;

        if (songContext.liked) {
          TableLikes.markSongLiked(songContext);
        } else {
          TableLikes.markSongNotLiked(songContext);
        }

        setState(() {});
      },
    );
  }
}
