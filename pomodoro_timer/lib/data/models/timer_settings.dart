import '../../core/constants/timer_constants.dart';

/// Represents the user's timer configuration.
/// Immutable model with copyWith support for easy updates.
class TimerSettings {
  final int workMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final bool isDarkMode;

  const TimerSettings({
    this.workMinutes = TimerConstants.defaultWorkMinutes,
    this.shortBreakMinutes = TimerConstants.defaultShortBreakMinutes,
    this.longBreakMinutes = TimerConstants.defaultLongBreakMinutes,
    this.isDarkMode = false,
  });

  /// Creates a copy with optional overrides.
  TimerSettings copyWith({
    int? workMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    bool? isDarkMode,
  }) {
    return TimerSettings(
      workMinutes: workMinutes ?? this.workMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  /// Converts settings to a map for SharedPreferences storage.
  Map<String, dynamic> toMap() {
    return {
      'workMinutes': workMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'isDarkMode': isDarkMode,
    };
  }

  /// Creates settings from a map.
  factory TimerSettings.fromMap(Map<String, dynamic> map) {
    return TimerSettings(
      workMinutes: map['workMinutes'] as int? ?? TimerConstants.defaultWorkMinutes,
      shortBreakMinutes: map['shortBreakMinutes'] as int? ?? TimerConstants.defaultShortBreakMinutes,
      longBreakMinutes: map['longBreakMinutes'] as int? ?? TimerConstants.defaultLongBreakMinutes,
      isDarkMode: map['isDarkMode'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerSettings &&
          runtimeType == other.runtimeType &&
          workMinutes == other.workMinutes &&
          shortBreakMinutes == other.shortBreakMinutes &&
          longBreakMinutes == other.longBreakMinutes &&
          isDarkMode == other.isDarkMode;

  @override
  int get hashCode =>
      workMinutes.hashCode ^
      shortBreakMinutes.hashCode ^
      longBreakMinutes.hashCode ^
      isDarkMode.hashCode;
}
