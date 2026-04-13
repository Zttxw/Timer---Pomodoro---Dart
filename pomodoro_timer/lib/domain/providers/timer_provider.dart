import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Represents the current state of the timer.
enum TimerState { idle, running, paused, finished }

/// Represents the type of timer session.
enum SessionType { work, shortBreak, longBreak }

/// Core timer logic provider using Ticker for smooth 60fps updates.
///
/// Manages the countdown, progress calculation, and state transitions.
/// Uses [Ticker] instead of [Timer] for frame-accurate updates that
/// synchronize with the display refresh rate.
class TimerProvider extends ChangeNotifier {
  // ─── State ─────────────────────────────────────────────────────────

  TimerState _state = TimerState.idle;
  SessionType _sessionType = SessionType.work;

  int _totalDurationSeconds = 25 * 60;
  int _remainingSeconds = 25 * 60;
  double _progress = 1.0;
  int _completedSessions = 0;

  // ─── Ticker for smooth animation ──────────────────────────────────

  Ticker? _ticker;
  int _secondsAtStart = 0;

  // ─── Getters ───────────────────────────────────────────────────────

  TimerState get state => _state;
  SessionType get sessionType => _sessionType;
  int get totalDurationSeconds => _totalDurationSeconds;
  int get remainingSeconds => _remainingSeconds;
  double get progress => _progress;
  int get completedSessions => _completedSessions;

  String get displayMinutes =>
      (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
  String get displaySeconds =>
      (_remainingSeconds % 60).toString().padLeft(2, '0');
  String get displayTime => '$displayMinutes:$displaySeconds';

  bool get isRunning => _state == TimerState.running;
  bool get isPaused => _state == TimerState.paused;
  bool get isIdle => _state == TimerState.idle;
  bool get isFinished => _state == TimerState.finished;

  String get sessionLabel {
    switch (_sessionType) {
      case SessionType.work:
        return 'FOCUS';
      case SessionType.shortBreak:
        return 'SHORT BREAK';
      case SessionType.longBreak:
        return 'LONG BREAK';
    }
  }

  // ─── Configuration ─────────────────────────────────────────────────

  /// Sets the timer duration in minutes. Only effective when idle.
  void setDuration(int minutes) {
    if (_state != TimerState.idle) return;
    _totalDurationSeconds = minutes * 60;
    _remainingSeconds = _totalDurationSeconds;
    _progress = 1.0;
    notifyListeners();
  }

  /// Sets the session type and updates duration accordingly.
  void setSessionType(SessionType type, {required int workMinutes, required int shortBreakMinutes, required int longBreakMinutes}) {
    _sessionType = type;
    switch (type) {
      case SessionType.work:
        setDuration(workMinutes);
        break;
      case SessionType.shortBreak:
        setDuration(shortBreakMinutes);
        break;
      case SessionType.longBreak:
        setDuration(longBreakMinutes);
        break;
    }
  }

  // ─── Controls ──────────────────────────────────────────────────────

  /// Starts or resumes the timer.
  void start(TickerProvider vsync) {
    if (_state == TimerState.running) return;

    if (_state == TimerState.finished || _state == TimerState.idle) {
      _remainingSeconds = _totalDurationSeconds;
      _progress = 1.0;
    }

    _state = TimerState.running;
    _secondsAtStart = _remainingSeconds;

    _ticker?.dispose();
    _ticker = vsync.createTicker(_onTick);
    _ticker!.start();

    notifyListeners();
  }

  /// Pauses the timer.
  void pause() {
    if (_state != TimerState.running) return;
    _state = TimerState.paused;
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    notifyListeners();
  }

  /// Toggles between running and paused states.
  void togglePlayPause(TickerProvider vsync) {
    if (_state == TimerState.running) {
      pause();
    } else {
      start(vsync);
    }
  }

  /// Resets the timer to its initial state.
  void reset() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;

    _state = TimerState.idle;
    _remainingSeconds = _totalDurationSeconds;
    _progress = 1.0;
    notifyListeners();
  }

  // ─── Tick Handler ──────────────────────────────────────────────────

  void _onTick(Duration elapsed) {
    final elapsedSeconds = elapsed.inMilliseconds / 1000.0;
    final newRemaining = _secondsAtStart - elapsedSeconds;

    if (newRemaining <= 0) {
      _remainingSeconds = 0;
      _progress = 0.0;
      _state = TimerState.finished;
      _completedSessions++;

      _ticker?.stop();
      _ticker?.dispose();
      _ticker = null;

      notifyListeners();
      return;
    }

    final newRemainingInt = newRemaining.ceil();
    // Smooth progress: use fractional seconds for fluid animation
    _progress = newRemaining / _totalDurationSeconds;
    
    if (newRemainingInt != _remainingSeconds) {
      _remainingSeconds = newRemainingInt;
    }

    notifyListeners();
  }

  // ─── Cleanup ───────────────────────────────────────────────────────

  @override
  void dispose() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }
}
