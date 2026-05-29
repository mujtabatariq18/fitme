import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../../onboarding/application/profile_controller.dart';
import '../../onboarding/domain/user_profile.dart';
import '../data/workout_seed.dart';
import '../domain/exercise.dart';
import 'workout_detail_screen.dart';

class WorkoutsScreen extends ConsumerStatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  ConsumerState<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends ConsumerState<WorkoutsScreen> {
  BodyArea? _filter;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    // Default the filter view to the user's first focus area.
    final focusAreas = profile.problemAreas.toList();
    final routines = _filter == null
        ? WorkoutSeed.all
        : WorkoutSeed.forArea(_filter!);

    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.sm, Insets.screenH, Insets.huge),
        children: [
          if (focusAreas.isNotEmpty) ...[
            Text('Your focus', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Insets.sm),
          ],
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                for (final a in BodyArea.values)
                  Padding(
                    padding: const EdgeInsets.only(left: Insets.sm),
                    child: _FilterChip(
                      label: a.label,
                      selected: _filter == a,
                      onTap: () => setState(() => _filter = a),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          for (final r in routines) _RoutineCard(routine: r),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.lg, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.pink : fit.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: selected ? AppColors.pink : fit.border),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : fit.textPrimary,
                fontSize: 14)),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  const _RoutineCard({required this.routine});
  final WorkoutRoutine routine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: FitCard(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => WorkoutDetailScreen(routine: routine))),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.pinkTint,
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              alignment: Alignment.center,
              child: Text(routine.emoji, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(routine.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                      '${routine.area.label} · ${routine.difficulty.label}',
                      style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: Insets.xs),
                  Row(children: [
                    _pill(context, '⏱ ${routine.durationMin}m'),
                    const SizedBox(width: Insets.xs),
                    _pill(context, '🔥 ${routine.estKcal}'),
                    const SizedBox(width: Insets.xs),
                    _pill(context, '${routine.exerciseCount} moves'),
                  ]),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  Widget _pill(BuildContext context, String text) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: Insets.sm, vertical: 2),
        decoration: BoxDecoration(
          color: context.fit.surfaceAlt,
          borderRadius: BorderRadius.circular(Radii.pill),
        ),
        child: Text(text, style: Theme.of(context).textTheme.labelMedium),
      );
}
