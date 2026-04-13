import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/providers/theme_provider.dart';

/// Animated toggle between light and dark themes.
class AnimatedThemeSwitch extends StatelessWidget {
  const AnimatedThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return IconButton(
      onPressed: () => themeProvider.toggleTheme(),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => RotationTransition(
          turns: child.key == const ValueKey('dark')
              ? Tween<double>(begin: 1, end: 0).animate(anim)
              : Tween<double>(begin: 0.75, end: 1).animate(anim),
          child: ScaleTransition(scale: anim, child: child),
        ),
        child: isDark
            ? const Icon(
                CupertinoIcons.moon_stars_fill,
                key: ValueKey('dark'),
                color: AppColors.darkPrimary,
              )
            : const Icon(
                CupertinoIcons.sun_max_fill,
                key: ValueKey('light'),
                color: AppColors.lightPrimary,
              ),
      ),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
    );
  }
}
