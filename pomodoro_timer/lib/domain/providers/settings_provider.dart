import 'package:flutter/material.dart';
import '../../data/models/timer_settings.dart';
import '../../data/repositories/settings_repository.dart';

/// Manages user settings with persistence.
class SettingsProvider extends ChangeNotifier {
  final SettingsRepository _repository;
  TimerSettings _settings;

  SettingsProvider({
    required SettingsRepository repository,
    required TimerSettings initialSettings,
  })  : _repository = repository,
        _settings = initialSettings;

  // ─── Getters ───────────────────────────────────────────────────────

  TimerSettings get settings => _settings;
  int get workMinutes => _settings.workMinutes;
  int get shortBreakMinutes => _settings.shortBreakMinutes;
  int get longBreakMinutes => _settings.longBreakMinutes;

  // ─── Setters ───────────────────────────────────────────────────────

  /// Updates work session duration.
  Future<void> setWorkMinutes(int minutes) async {
    _settings = _settings.copyWith(workMinutes: minutes);
    notifyListeners();
    await _repository.saveSettings(_settings);
  }

  /// Updates short break duration.
  Future<void> setShortBreakMinutes(int minutes) async {
    _settings = _settings.copyWith(shortBreakMinutes: minutes);
    notifyListeners();
    await _repository.saveSettings(_settings);
  }

  /// Updates long break duration.
  Future<void> setLongBreakMinutes(int minutes) async {
    _settings = _settings.copyWith(longBreakMinutes: minutes);
    notifyListeners();
    await _repository.saveSettings(_settings);
  }

  /// Updates all settings at once.
  Future<void> updateSettings(TimerSettings newSettings) async {
    _settings = newSettings;
    notifyListeners();
    await _repository.saveSettings(_settings);
  }
}
