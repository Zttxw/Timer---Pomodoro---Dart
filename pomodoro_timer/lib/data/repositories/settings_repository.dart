import 'package:shared_preferences/shared_preferences.dart';
import '../models/timer_settings.dart';

/// Handles persistence of user settings via SharedPreferences.
class SettingsRepository {
  static const String _keyWorkMinutes = 'work_minutes';
  static const String _keyShortBreakMinutes = 'short_break_minutes';
  static const String _keyLongBreakMinutes = 'long_break_minutes';
  static const String _keyIsDarkMode = 'is_dark_mode';

  final SharedPreferences _prefs;

  SettingsRepository(this._prefs);

  /// Loads all saved settings. Returns defaults if none are saved.
  TimerSettings loadSettings() {
    return TimerSettings(
      workMinutes: _prefs.getInt(_keyWorkMinutes) ?? 25,
      shortBreakMinutes: _prefs.getInt(_keyShortBreakMinutes) ?? 5,
      longBreakMinutes: _prefs.getInt(_keyLongBreakMinutes) ?? 15,
      isDarkMode: _prefs.getBool(_keyIsDarkMode) ?? false,
    );
  }

  /// Persists the given settings.
  Future<void> saveSettings(TimerSettings settings) async {
    await Future.wait([
      _prefs.setInt(_keyWorkMinutes, settings.workMinutes),
      _prefs.setInt(_keyShortBreakMinutes, settings.shortBreakMinutes),
      _prefs.setInt(_keyLongBreakMinutes, settings.longBreakMinutes),
      _prefs.setBool(_keyIsDarkMode, settings.isDarkMode),
    ]);
  }

  /// Saves only the dark mode preference.
  Future<void> saveDarkMode(bool isDarkMode) async {
    await _prefs.setBool(_keyIsDarkMode, isDarkMode);
  }
}
