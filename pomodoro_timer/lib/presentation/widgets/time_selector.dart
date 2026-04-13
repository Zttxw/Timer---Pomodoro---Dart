import 'package:flutter/material.dart';
import '../../core/constants/timer_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// A sleek slider for selecting time duration.
class TimeSelector extends StatelessWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final bool isDarkMode;

  const TimeSelector({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.labelLarge(
                isDarkMode ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              '$value min',
              style: AppTextStyles.bodyMedium(
                isDarkMode ? AppColors.darkPrimary : AppColors.lightPrimary,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value.toDouble(),
          min: TimerConstants.minMinutes.toDouble(),
          max: TimerConstants.maxMinutes.toDouble(),
          divisions: TimerConstants.maxMinutes - TimerConstants.minMinutes,
          onChanged: (newValue) => onChanged(newValue.toInt()),
        ),
        const SizedBox(height: 8),
        // Preset shortcuts
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: TimerConstants.presetMinutes.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final preset = TimerConstants.presetMinutes[index];
              final isSelected = preset == value;

              return InkWell(
                onTap: () => onChanged(preset),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSelected
                        ? (isDarkMode
                            ? AppColors.darkPrimary.withValues(alpha: 0.2)
                            : AppColors.lightPrimary.withValues(alpha: 0.1))
                        : (isDarkMode
                            ? AppColors.darkSurfaceVariant
                            : AppColors.lightSurfaceVariant),
                    border: Border.all(
                      color: isSelected
                          ? (isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    '$preset',
                    style: AppTextStyles.labelMedium(
                      isSelected
                          ? (isDarkMode
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          : (isDarkMode
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
