import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/theme_provider.dart';
import '../../domain/providers/timer_provider.dart';
import '../widgets/animated_theme_switch.dart';
import '../widgets/time_selector.dart';

/// Screen for user configurations.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: const [
          AnimatedThemeSwitch(),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timer Durations',
              style: AppTextStyles.heading2(
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customize the length of your focus sessions and breaks.',
              style: AppTextStyles.bodyMedium(
                isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _SettingsContent(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  final bool isDark;

  const _SettingsContent({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final timerProvider = context.read<TimerProvider>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TimeSelector(
              label: 'Focus Time',
              value: settingsProvider.workMinutes,
              isDarkMode: isDark,
              onChanged: (newMinutes) async {
                await settingsProvider.setWorkMinutes(newMinutes);
                _updateTimerIfIdle(
                  timerProvider,
                  settingsProvider,
                  SessionType.work,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
            ),
            TimeSelector(
              label: 'Short Break',
              value: settingsProvider.shortBreakMinutes,
              isDarkMode: isDark,
              onChanged: (newMinutes) async {
                await settingsProvider.setShortBreakMinutes(newMinutes);
                _updateTimerIfIdle(
                  timerProvider,
                  settingsProvider,
                  SessionType.shortBreak,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider),
            ),
            TimeSelector(
              label: 'Long Break',
              value: settingsProvider.longBreakMinutes,
              isDarkMode: isDark,
              onChanged: (newMinutes) async {
                await settingsProvider.setLongBreakMinutes(newMinutes);
                _updateTimerIfIdle(
                  timerProvider,
                  settingsProvider,
                  SessionType.longBreak,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _updateTimerIfIdle(TimerProvider timer, SettingsProvider settings,
      SessionType affectedType) {
    if (timer.isIdle && timer.sessionType == affectedType) {
      timer.setSessionType(
        affectedType,
        workMinutes: settings.workMinutes,
        shortBreakMinutes: settings.shortBreakMinutes,
        longBreakMinutes: settings.longBreakMinutes,
      );
    }
  }
}
