import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/fit_card.dart';
import '../../../core/widgets/metric_ring.dart';
import '../../onboarding/application/profile_controller.dart';
import '../../onboarding/domain/user_profile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final fit = context.fit;
    final target = p.dailyCalorieTarget ?? 2000;
    // Placeholder "consumed so far" until food logging lands.
    const consumed = 1180;
    final macros = p.macros;

    return Scaffold(
      body: BlobBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                Insets.screenH, Insets.lg, Insets.screenH, Insets.huge),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Good morning 👋',
                          style: Theme.of(context).textTheme.bodyMedium),
                      Text(p.name.isEmpty ? 'Let\'s move' : p.name,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.push('/settings'),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.pinkTint,
                      child: Icon(_genderIcon(p.gender),
                          color: AppColors.deepMagenta),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.xl),

              // Calorie ring card
              FitCard(
                padding: const EdgeInsets.all(Insets.xl),
                child: Column(
                  children: [
                    MetricRing(
                      progress: consumed / target,
                      color: AppColors.pink,
                      size: 180,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('${target - consumed}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(color: fit.textPrimary)),
                          Text('kcal left',
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: Insets.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(label: 'Eaten', value: '$consumed'),
                        _Stat(label: 'Target', value: '$target'),
                        _Stat(label: 'Burned', value: '420'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Insets.lg),

              // Macros
              if (macros != null)
                FitCard(
                  child: Row(
                    children: [
                      _MacroBar(
                          label: 'Protein',
                          value: 0.55,
                          color: AppColors.pink,
                          grams: macros.protein),
                      _MacroBar(
                          label: 'Carbs',
                          value: 0.4,
                          color: AppColors.blue,
                          grams: macros.carbs),
                      _MacroBar(
                          label: 'Fat',
                          value: 0.7,
                          color: AppColors.calories,
                          grams: macros.fat),
                    ],
                  ),
                ),
              const SizedBox(height: Insets.lg),

              // Quick actions
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.camera_alt_rounded,
                      label: 'Scan food',
                      color: AppColors.pink,
                      onTap: () => _soon(context, 'Food scanning'),
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.fitness_center_rounded,
                      label: 'Workout',
                      color: AppColors.deepMagenta,
                      onTap: () => _soon(context, 'Workouts'),
                    ),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.monitor_weight_rounded,
                      label: 'Add weight',
                      color: AppColors.blue,
                      onTap: () => _soon(context, 'Weight logging'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Insets.lg),

              // Focus areas
              Text('Your focus areas',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Insets.md),
              Wrap(
                spacing: Insets.sm,
                runSpacing: Insets.sm,
                children: [
                  for (final a in p.problemAreas)
                    Chip(
                      label: Text(a.label),
                      backgroundColor: AppColors.pinkTint,
                      labelStyle: const TextStyle(
                          color: AppColors.deepMagenta,
                          fontWeight: FontWeight.w600),
                      side: BorderSide.none,
                    ),
                  if (p.problemAreas.isEmpty)
                    Text('No focus areas yet',
                        style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _genderIcon(Gender g) => switch (g) {
        Gender.male => Icons.male_rounded,
        Gender.female => Icons.female_rounded,
        Gender.nonBinary => Icons.person_rounded,
      };

  void _soon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming in the next phase')),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.titleLarge),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}

class _MacroBar extends StatelessWidget {
  const _MacroBar(
      {required this.label,
      required this.value,
      required this.color,
      required this.grams});
  final String label;
  final double value;
  final Color color;
  final int grams;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text('${grams}g',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Insets.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          const SizedBox(height: Insets.xs),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FitCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: Insets.lg),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: Insets.sm),
          Text(label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}
