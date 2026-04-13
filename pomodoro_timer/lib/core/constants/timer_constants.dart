/// Default timer constants and configuration limits.
class TimerConstants {
  TimerConstants._();

  // ─── Default Durations (in minutes) ────────────────────────────────

  /// Default work session duration.
  static const int defaultWorkMinutes = 25;

  /// Default short break duration.
  static const int defaultShortBreakMinutes = 5;

  /// Default long break duration.
  static const int defaultLongBreakMinutes = 15;

  // ─── Limits ────────────────────────────────────────────────────────

  /// Minimum configurable duration in minutes.
  static const int minMinutes = 1;

  /// Maximum configurable duration in minutes.
  static const int maxMinutes = 90;

  // ─── Presets ───────────────────────────────────────────────────────

  /// Quick-select preset durations in minutes.
  static const List<int> presetMinutes = [5, 10, 15, 20, 25, 30, 45, 60];

  // ─── Sessions ──────────────────────────────────────────────────────

  /// Number of work sessions before a long break.
  static const int sessionsBeforeLongBreak = 4;
}
