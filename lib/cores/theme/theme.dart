import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/theme/color_pellets.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: 3));
  static final darkThemeMode = ThemeData.dark().copyWith(
      chipTheme: const ChipThemeData(
          color: MaterialStatePropertyAll(AppPallete.backgroundColor),
          side: BorderSide.none),
      appBarTheme:
          const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
      scaffoldBackgroundColor: AppPallete.backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          border: _border(),
          focusedBorder: _border(AppPallete.gradient2),
          errorBorder: _border(AppPallete.errorColor),
          enabledBorder: _border()));

  static final lightThemeMode = ThemeData.light().copyWith(
      chipTheme: const ChipThemeData(
          color: MaterialStatePropertyAll(AppPallete.lightBackgroundColor),
          side: BorderSide.none),
      appBarTheme:
          const AppBarTheme(backgroundColor: AppPallete.lightBackgroundColor),
      scaffoldBackgroundColor: AppPallete.lightBackgroundColor,
      inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.all(27),
          border: _border(),
          focusedBorder: _border(AppPallete.lightGradient2),
          errorBorder: _border(AppPallete.errorColor),
          enabledBorder: _border()));
}
