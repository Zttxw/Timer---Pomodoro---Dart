import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/providers/timer_provider.dart';
import '../../../domain/providers/theme_provider.dart';
import 'timer_painter.dart';

/// The main circular timer widget.
///
/// Displays an animated progress ring around a centered time display.
/// Includes a subtle pulse animation when the timer finishes.
class CircularTimerWidget extends StatefulWidget {
  const CircularTimerWidget({super.key});

  @override
  State<CircularTimerWidget> createState() => _CircularTimerWidgetState();
}

class _CircularTimerWidgetState extends State<CircularTimerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    // Pulse animation when finished
    if (timerProvider.isFinished) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: timerProvider.isFinished ? _pulseAnimation.value : 1.0,
          child: child,
        );
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          final timerSize = size * 0.85;

          return SizedBox(
            width: timerSize,
            height: timerSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Circular progress ring
                CustomPaint(
                  size: Size(timerSize, timerSize),
                  painter: TimerPainter(
                    progress: timerProvider.progress,
                    timerState: timerProvider.state,
                    sessionType: timerProvider.sessionType,
                    isDarkMode: isDarkMode,
                  ),
                ),

                // Center content: time + session label
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Session label
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        timerProvider.sessionLabel,
                        key: ValueKey(timerProvider.sessionLabel),
                        style: AppTextStyles.timerLabel(
                          isDarkMode
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Time display
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      child: Text(
                        timerProvider.displayTime,
                        key: ValueKey(timerProvider.displayTime),
                        style: AppTextStyles.timerDisplay(
                          _getTimeColor(timerProvider, isDarkMode),
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Status indicator
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _buildStatusIndicator(timerProvider, isDarkMode),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getTimeColor(TimerProvider timer, bool isDarkMode) {
    if (timer.isFinished) {
      return AppColors.timerFinishedGradientStart;
    }
    return isDarkMode
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
  }

  Widget _buildStatusIndicator(TimerProvider timer, bool isDarkMode) {
    if (timer.isFinished) {
      return Text(
        'COMPLETED',
        key: const ValueKey('completed'),
        style: AppTextStyles.labelMedium(
          AppColors.timerFinishedGradientStart,
        ),
      );
    }
    if (timer.isPaused) {
      return Text(
        'PAUSED',
        key: const ValueKey('paused'),
        style: AppTextStyles.labelMedium(
          isDarkMode
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
      );
    }
    return const SizedBox(height: 14, key: ValueKey('empty'));
  }
}
