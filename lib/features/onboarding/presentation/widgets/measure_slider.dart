import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/fit_card.dart';

/// Large numeric readout + slider, used for height / weight selection.
class MeasureSlider extends StatelessWidget {
  const MeasureSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
    this.accent = AppColors.pink,
    this.fractionDigits = 0,
  });

  final double value;
  final double min;
  final double max;
  final String unit;
  final Color accent;
  final int fractionDigits;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return FitCard(
      padding: const EdgeInsets.symmetric(
          horizontal: Insets.xl, vertical: Insets.xxl),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value.toStringAsFixed(fractionDigits),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: accent,
                      fontSize: 52,
                    ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(unit,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: fit.textSecondary,
                        )),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: accent,
              inactiveTrackColor: accent.withValues(alpha: 0.15),
              thumbColor: accent,
              overlayColor: accent.withValues(alpha: 0.15),
              trackHeight: 6,
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toStringAsFixed(0)} $unit',
                  style: Theme.of(context).textTheme.labelMedium),
              Text('${max.toStringAsFixed(0)} $unit',
                  style: Theme.of(context).textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
