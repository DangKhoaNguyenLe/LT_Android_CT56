import 'package:flutter/material.dart';

class AppState {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);

  static void changeTheme(bool isDark) {
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}