import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'data/repositories/settings_repository.dart';
import 'domain/providers/settings_provider.dart';
import 'domain/providers/theme_provider.dart';
import 'domain/providers/timer_provider.dart';

void main() async {
  // Ensure flutter bindings are initialized before calling async methods
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final settingsRepo = SettingsRepository(prefs);

  // Load initial settings
  final initialSettings = settingsRepo.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            repository: settingsRepo,
            isDarkMode: initialSettings.isDarkMode,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(
            repository: settingsRepo,
            initialSettings: initialSettings,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              TimerProvider()..setDuration(initialSettings.workMinutes),
        ),
      ],
      child: const PomodoroApp(),
    ),
  );
}
