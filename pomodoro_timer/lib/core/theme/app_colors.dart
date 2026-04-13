import 'package:flutter/material.dart';

/// Defines the complete color palette for the Pomodoro Timer application.
/// Uses soft, harmonious tones for a professional, minimalist aesthetic.
class AppColors {
  AppColors._();

  // ─── Light Theme Colors ────────────────────────────────────────────

  static const Color lightPrimary = Color(0xFF6B9FD4);
  static const Color lightPrimaryDark = Color(0xFF4A7FB5);
  static const Color lightAccent = Color(0xFF7EC8A0);
  static const Color lightAccentDark = Color(0xFF5DAF82);

  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF0F2F5);
  static const Color lightCardBackground = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF2D3142);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightTextTertiary = Color(0xFF9CA3AF);

  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightShadow = Color(0x1A000000);

  // ─── Dark Theme Colors ─────────────────────────────────────────────

  static const Color darkPrimary = Color(0xFF7DAFE0);
  static const Color darkPrimaryDark = Color(0xFF5B95D1);
  static const Color darkAccent = Color(0xFF8DD4AD);
  static const Color darkAccentDark = Color(0xFF6BBF91);

  static const Color darkBackground = Color(0xFF1A1D23);
  static const Color darkSurface = Color(0xFF22262E);
  static const Color darkSurfaceVariant = Color(0xFF2A2F38);
  static const Color darkCardBackground = Color(0xFF262B33);

  static const Color darkTextPrimary = Color(0xFFE8ECF1);
  static const Color darkTextSecondary = Color(0xFF9BA4B0);
  static const Color darkTextTertiary = Color(0xFF6B7280);

  static const Color darkDivider = Color(0xFF353A45);
  static const Color darkShadow = Color(0x40000000);

  // ─── Semantic Colors ───────────────────────────────────────────────

  static const Color success = Color(0xFF7EC8A0);
  static const Color warning = Color(0xFFE8B86D);
  static const Color error = Color(0xFFE07B7B);
  static const Color info = Color(0xFF6B9FD4);

  // ─── Timer-specific Colors ─────────────────────────────────────────

  static const Color timerWorkGradientStart = Color(0xFF6B9FD4);
  static const Color timerWorkGradientEnd = Color(0xFF4A7FB5);

  static const Color timerBreakGradientStart = Color(0xFF7EC8A0);
  static const Color timerBreakGradientEnd = Color(0xFF5DAF82);

  static const Color timerFinishedGradientStart = Color(0xFFE8B86D);
  static const Color timerFinishedGradientEnd = Color(0xFFD4A05A);

  static const Color timerTrackLight = Color(0xFFE8ECF1);
  static const Color timerTrackDark = Color(0xFF2A2F38);
}
