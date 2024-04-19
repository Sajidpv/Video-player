import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: AppPallete.gradient1,
        content: Text(
          content,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
}
