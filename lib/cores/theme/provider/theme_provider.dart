import 'package:flutter/material.dart';
import 'package:video_player_lilac/cores/theme/theme.dart';

class ThemeProvider with ChangeNotifier {
  bool val = true;
  ThemeData _themeData = AppTheme.darkThemeMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    val = !val;
    if (val == true) {
      themeData = AppTheme.darkThemeMode;
    } else {
      themeData = AppTheme.lightThemeMode;
    }
  }
}
