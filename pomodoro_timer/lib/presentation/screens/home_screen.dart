import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/theme_provider.dart';
import '../../domain/providers/timer_provider.dart';
import '../widgets/animated_theme_switch.dart';
import '../widgets/circular_timer/circular_timer_widget.dart';
import '../widgets/timer_controls.dart';
import 'settings_screen.dart';

/// The main screen of the application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          const AnimatedThemeSwitch(),
          IconButton(
            icon: const Icon(CupertinoIcons.settings),
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const SettingsScreen(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.easeInOutBack;
                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Session Type Selector
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: _SessionSelectorWidget(isDark: isDark),
            ),

            // Flexible space for center alignment
            const Spacer(),

            // Circular Timer
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: CircularTimerWidget(),
              ),
            ),

            const Spacer(),

            // Timer Controls
            const Padding(
              padding: EdgeInsets.only(bottom: 48.0),
              child: TimerControls(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionSelectorWidget extends StatelessWidget {
  final bool isDark;

  const _SessionSelectorWidget({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final settingsProvider = context.watch<SettingsProvider>();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: SessionType.values.map((type) {
          final isSelected = timerProvider.sessionType == type;
          String label;
          switch (type) {
            case SessionType.work:
              label = 'Focus';
              break;
            case SessionType.shortBreak:
              label = 'Short Break';
              break;
            case SessionType.longBreak:
              label = 'Long Break';
              break;
          }

          return GestureDetector(
            onTap: () {
              if (timerProvider.isIdle) {
                timerProvider.setSessionType(
                  type,
                  workMinutes: settingsProvider.workMinutes,
                  shortBreakMinutes: settingsProvider.shortBreakMinutes,
                  longBreakMinutes: settingsProvider.longBreakMinutes,
                );
              } else if (!isSelected) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pause or reset the timer to change session type',
                      style: AppTextStyles.bodyMedium(Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(26),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Text(
                label,
                style: AppTextStyles.labelLarge(
                  isSelected
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ).copyWith(fontWeight: isSelected ? FontWeight.w700 : null),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
