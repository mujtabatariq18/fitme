import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/selection_tile.dart';
import '../../application/profile_controller.dart';
import '../../domain/user_profile.dart';
import 'measure_slider.dart';

// ── Gender ───────────────────────────────────────────────────────────────────
class GenderStep extends ConsumerWidget {
  const GenderStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(profileProvider).gender;
    final ctrl = ref.read(profileProvider.notifier);
    const items = [
      (Gender.female, 'Female', Icons.female_rounded),
      (Gender.male, 'Male', Icons.male_rounded),
      (Gender.nonBinary, 'Non-binary', Icons.transgender_rounded),
    ];
    return Column(
      children: [
        for (final (g, label, icon) in items)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: _GenderCard(
              label: label,
              icon: icon,
              selected: selected == g,
              onTap: () => ctrl.setGender(g),
            ),
          ),
        const SizedBox(height: Insets.sm),
        Text(
          'We use this to tailor your avatar, workouts and calorie targets.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _GenderCard extends StatelessWidget {
  const _GenderCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: selected ? AppColors.pinkTint : fit.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: selected ? AppColors.pink : fit.border,
            width: selected ? 2 : 1.4,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.pink : fit.surfaceAlt,
              ),
              child: Icon(icon,
                  color: selected ? Colors.white : fit.textSecondary, size: 26),
            ),
            const SizedBox(width: Insets.lg),
            Text(label, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}

// ── Goal ─────────────────────────────────────────────────────────────────────
class GoalStep extends ConsumerWidget {
  const GoalStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(profileProvider).goal;
    final ctrl = ref.read(profileProvider.notifier);
    return Column(
      children: [
        for (final g in FitnessGoal.values)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: SelectionTile(
              label: g.label,
              selected: selected == g,
              onTap: () => ctrl.setGoal(g),
            ),
          ),
      ],
    );
  }
}

// ── Problem areas (multi-select) ─────────────────────────────────────────────
class AreasStep extends ConsumerWidget {
  const AreasStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final areas = ref.watch(profileProvider).problemAreas;
    final ctrl = ref.read(profileProvider.notifier);
    return Wrap(
      spacing: Insets.md,
      runSpacing: Insets.md,
      alignment: WrapAlignment.center,
      children: [
        for (final a in BodyArea.values)
          _AreaChip(
            label: a.label,
            selected: areas.contains(a),
            onTap: () => ctrl.toggleArea(a),
          ),
      ],
    );
  }
}

class _AreaChip extends StatelessWidget {
  const _AreaChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Motion.fast,
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.xl, vertical: Insets.md),
        decoration: BoxDecoration(
          color: selected ? AppColors.pink : fit.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(
            color: selected ? AppColors.pink : fit.border,
            width: 1.6,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : fit.textPrimary,
              ),
        ),
      ),
    );
  }
}

// ── Body stats ───────────────────────────────────────────────────────────────
class BodyStatsStep extends ConsumerWidget {
  const BodyStatsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final ctrl = ref.read(profileProvider.notifier);
    final age = p.age ?? 28;
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Age', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: Insets.sm),
        MeasureSlider(
          value: age.toDouble(),
          min: 13,
          max: 90,
          unit: 'yrs',
          accent: AppColors.deepMagenta,
          onChanged: (v) => ctrl.setBirthYear(2026 - v.round()),
        ),
        const SizedBox(height: Insets.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Height', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: Insets.sm),
        MeasureSlider(
          value: p.heightCm ?? 165,
          min: 120,
          max: 220,
          unit: 'cm',
          onChanged: ctrl.setHeight,
        ),
        const SizedBox(height: Insets.xl),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Current weight',
              style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: Insets.sm),
        MeasureSlider(
          value: p.currentWeightKg ?? 65,
          min: 35,
          max: 200,
          unit: 'kg',
          onChanged: ctrl.setCurrentWeight,
        ),
      ],
    );
  }
}

// ── Target weight ─────────────────────────────────────────────────────────────
class TargetWeightStep extends ConsumerWidget {
  const TargetWeightStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final ctrl = ref.read(profileProvider.notifier);
    final current = p.currentWeightKg ?? 65;
    final target = p.targetWeightKg ?? current;
    final delta = (current - target);
    final losing = delta > 0;
    return Column(
      children: [
        MeasureSlider(
          value: target,
          min: 35,
          max: 200,
          unit: 'kg',
          accent: AppColors.blue,
          fractionDigits: 1,
          onChanged: ctrl.setTargetWeight,
        ),
        const SizedBox(height: Insets.xl),
        if (delta.abs() >= 0.1)
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Insets.xl, vertical: Insets.md),
            decoration: BoxDecoration(
              color: AppColors.blueTint.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: Text(
              '${losing ? "Lose" : "Gain"} ${delta.abs().toStringAsFixed(1)} kg',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.blueDark,
                  ),
            ),
          ),
      ],
    );
  }
}

// ── Activity ─────────────────────────────────────────────────────────────────
class ActivityStep extends ConsumerWidget {
  const ActivityStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(profileProvider).activityLevel;
    final ctrl = ref.read(profileProvider.notifier);
    return Column(
      children: [
        for (final a in ActivityLevel.values)
          Padding(
            padding: const EdgeInsets.only(bottom: Insets.md),
            child: SelectionTile(
              label: a.label,
              selected: selected == a,
              onTap: () => ctrl.setActivity(a),
            ),
          ),
      ],
    );
  }
}

// ── Diet ─────────────────────────────────────────────────────────────────────
class DietStep extends ConsumerWidget {
  const DietStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(profileProvider).dietType;
    final ctrl = ref.read(profileProvider.notifier);
    return Wrap(
      spacing: Insets.md,
      runSpacing: Insets.md,
      alignment: WrapAlignment.center,
      children: [
        for (final d in DietType.values)
          _AreaChip(
            label: d.label,
            selected: selected == d,
            onTap: () => ctrl.setDiet(d),
          ),
      ],
    );
  }
}
