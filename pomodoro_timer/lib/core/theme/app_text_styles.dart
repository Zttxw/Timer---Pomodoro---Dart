import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Defines all text styles used throughout the application.
/// Uses Google Fonts for a professional, modern appearance.
class AppTextStyles {
  AppTextStyles._();

  /// Primary font family for general text.
  static String get _fontFamily => GoogleFonts.inter().fontFamily!;

  /// Monospaced font for timer digits.
  static String get _timerFontFamily => GoogleFonts.outfit().fontFamily!;

  // ─── Headings ──────────────────────────────────────────────────────

  static TextStyle heading1(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle heading2(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.3,
        height: 1.3,
      );

  static TextStyle heading3(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -0.2,
        height: 1.3,
      );

  // ─── Body ──────────────────────────────────────────────────────────

  static TextStyle bodyLarge(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodyMedium(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.5,
      );

  static TextStyle bodySmall(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.4,
      );

  // ─── Labels ────────────────────────────────────────────────────────

  static TextStyle labelLarge(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.3,
        height: 1.4,
      );

  static TextStyle labelMedium(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.4,
        height: 1.4,
      );

  // ─── Timer-specific ────────────────────────────────────────────────

  /// Large timer display (MM:SS).
  static TextStyle timerDisplay(Color color) => TextStyle(
        fontFamily: _timerFontFamily,
        fontSize: 56,
        fontWeight: FontWeight.w300,
        color: color,
        letterSpacing: 2.0,
        height: 1.0,
      );

  /// Secondary timer info (e.g., session label).
  static TextStyle timerLabel(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 1.5,
        height: 1.4,
      );

  // ─── Button ────────────────────────────────────────────────────────

  static TextStyle button(Color color) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 0.5,
        height: 1.0,
      );
}
