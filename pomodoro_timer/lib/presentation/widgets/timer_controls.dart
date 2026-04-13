import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/theme_provider.dart';
import '../../../domain/providers/timer_provider.dart';

/// Animated controls for the timer (Play/Pause, Reset).
class TimerControls extends StatefulWidget {
  const TimerControls({super.key});

  @override
  State<TimerControls> createState() => _TimerControlsState();
}

class _TimerControlsState extends State<TimerControls>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final baseColor = isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset Button
        AnimatedOpacity(
          opacity: timerProvider.isIdle ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: timerProvider.isIdle,
            child: IconButton(
              onPressed: () => timerProvider.reset(),
              icon: const Icon(CupertinoIcons.arrow_counterclockwise),
              iconSize: 28,
              color: isDarkMode
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              tooltip: 'Reset',
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Play/Pause Button
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: timerProvider.isFinished
                ? AppColors.timerFinishedGradientStart
                : baseColor,
            boxShadow: [
              BoxShadow(
                color: (timerProvider.isFinished
                        ? AppColors.timerFinishedGradientStart
                        : baseColor)
                    .withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: timerProvider.isFinished
                  ? () => timerProvider.reset()
                  : () => timerProvider.togglePlayPause(this),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    _getIcon(timerProvider),
                    key: ValueKey(_getIcon(timerProvider)),
                    size: 36,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 24),

        // Placeholder for symmetry
        const SizedBox(width: 48),
      ],
    );
  }

  IconData _getIcon(TimerProvider timer) {
    if (timer.isFinished) return CupertinoIcons.refresh;
    if (timer.isRunning) return CupertinoIcons.pause;
    return CupertinoIcons.play_arrow_solid;
  }
}
