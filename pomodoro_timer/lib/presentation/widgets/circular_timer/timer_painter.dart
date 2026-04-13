import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/timer_provider.dart';

/// Custom painter that draws the circular timer progress ring.
///
/// Draws three layers:
/// 1. Background track (subtle ring)
/// 2. Progress arc with gradient
/// 3. Leading dot indicator at the current position
class TimerPainter extends CustomPainter {
  final double progress;
  final TimerState timerState;
  final SessionType sessionType;
  final bool isDarkMode;

  TimerPainter({
    required this.progress,
    required this.timerState,
    required this.sessionType,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 16;
    const strokeWidth = 6.0;

    // ─── Determine colors based on session type ────────────────────
    Color gradientStart = AppColors.timerWorkGradientStart;
    Color gradientEnd = AppColors.timerWorkGradientEnd;

    if (timerState == TimerState.finished) {
      gradientStart = AppColors.timerFinishedGradientStart;
      gradientEnd = AppColors.timerFinishedGradientEnd;
    } else {
      switch (sessionType) {
        case SessionType.work:
          gradientStart = AppColors.timerWorkGradientStart;
          gradientEnd = AppColors.timerWorkGradientEnd;
          break;
        case SessionType.shortBreak:
        case SessionType.longBreak:
          gradientStart = AppColors.timerBreakGradientStart;
          gradientEnd = AppColors.timerBreakGradientEnd;
          break;
      }
    }

    // ─── 1. Background Track ───────────────────────────────────────
    final trackPaint = Paint()
      ..color = isDarkMode ? AppColors.timerTrackDark : AppColors.timerTrackLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // ─── 2. Progress Arc ───────────────────────────────────────────
    if (progress > 0) {
      final sweepAngle = 2 * math.pi * progress;
      const startAngle = -math.pi / 2; // Start from top

      // Create gradient shader
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        colors: [gradientStart, gradientEnd, gradientStart],
        stops: const [0.0, 0.5, 1.0],
        transform: const GradientRotation(-math.pi / 2),
      );

      final progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..shader = gradient.createShader(rect);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // ─── 3. Leading Dot Indicator ──────────────────────────────────
      final dotAngle = startAngle + sweepAngle;
      final dotX = center.dx + radius * math.cos(dotAngle);
      final dotY = center.dy + radius * math.sin(dotAngle);

      // Glow effect
      final glowPaint = Paint()
        ..color = gradientStart.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawCircle(Offset(dotX, dotY), 6, glowPaint);

      // Solid dot
      final dotPaint = Paint()
        ..color = gradientStart
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), 4, dotPaint);

      // White center of dot
      final dotCenterPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dotX, dotY), 1.5, dotCenterPaint);
    }
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.timerState != timerState ||
        oldDelegate.sessionType != sessionType ||
        oldDelegate.isDarkMode != isDarkMode;
  }
}
