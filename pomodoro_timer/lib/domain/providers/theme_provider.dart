import 'package:flutter/material.dart';
import '../../data/repositories/settings_repository.dart';

/// Manages the application theme (light/dark mode) with persistence.
class ThemeProvider extends ChangeNotifier {
  final SettingsRepository _repository;
  bool _isDarkMode;

  ThemeProvider({
    required SettingsRepository repository,
    required bool isDarkMode,
  })  : _repository = repository,
        _isDarkMode = isDarkMode;

  // ─── Getters ───────────────────────────────────────────────────────

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // ─── Toggle ────────────────────────────────────────────────────────

  /// Toggles between light and dark mode.
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    await _repository.saveDarkMode(_isDarkMode);
  }
}
