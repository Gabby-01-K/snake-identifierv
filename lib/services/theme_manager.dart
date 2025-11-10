// lib/services/theme_manager.dart

import 'package:flutter/material.dart';

// Using an enum to define the 3 theme states
enum ThemeModeState { system, light, dark }

class ThemeManager extends ChangeNotifier {
  // Default to following the system theme
  ThemeModeState _themeModeState = ThemeModeState.system;

  // This is a getter that converts our enum state into
  // the actual ThemeMode that Flutter's MaterialApp needs.
  ThemeMode get themeMode {
    switch (_themeModeState) {
      case ThemeModeState.light:
        return ThemeMode.light;
      case ThemeModeState.dark:
        return ThemeMode.dark;
      case ThemeModeState.system:
        return ThemeMode.system;
    }
  }

  ThemeModeState get themeModeState => _themeModeState;

  // This is the function we'll call to change the theme
  void setTheme(ThemeModeState state) {
    if (_themeModeState == state) return; // No change

    _themeModeState = state;
    // Notify all listeners (our MaterialApp) to rebuild
    notifyListeners();
  }
}