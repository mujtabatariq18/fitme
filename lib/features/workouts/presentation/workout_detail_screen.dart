import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/fit_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/exercise.dart';

class WorkoutDetailScreen extends StatelessWidget {
  const WorkoutDetailScreen({super.key, required this.routine});
  final WorkoutRoutine routine;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: AppColors.deepMagenta,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(routine.name,
                  style: const TextStyle(color: Colors.white)),
              background: Container(
                decoration: const BoxDecoration(gradient: AppGradients.brand),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Text(routine.emoji,
                        style: const TextStyle(fontSize: 64)),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(Insets.screenH),
            sliver: SliverList.list(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(Icons.timer_outlined, '${routine.durationMin} min'),
                  _Stat(Icons.local_fire_department_outlined,
                      '${routine.estKcal} kcal'),
                  _Stat(Icons.format_list_numbered_rounded,
                      '${routine.exerciseCount} moves'),
                  _Stat(Icons.bolt_outlined, routine.difficulty.label),
                ],
              ),
              const SizedBox(height: Insets.lg),
              if (routine.focus.isNotEmpty)
                Text(routine.focus,
                    style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: Insets.lg),
              for (var i = 0; i < routine.exercises.length; i++)
                _ExerciseTile(index: i + 1, exercise: routine.exercises[i]),
              const SizedBox(height: Insets.lg),
              PrimaryButton(
                label: 'Start workout',
                icon: Icons.play_arrow_rounded,
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(
                          'Guided player with animated avatars — next phase')),
                ),
              ),
              const SizedBox(height: Insets.xl),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.label);
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: AppColors.pink),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}

class _ExerciseTile extends StatefulWidget {
  const _ExerciseTile({required this.index, required this.exercise});
  final int index;
  final Exercise exercise;

  @override
  State<_ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<_ExerciseTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: FitCard(
        onTap: () => setState(() => _open = !_open),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.pinkTint,
                    borderRadius: BorderRadius.circular(Radii.sm),
                  ),
                  alignment: Alignment.center,
                  child: Text(e.emoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: Insets.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(e.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text('${e.volumeLabel} · ${e.equipment}',
                          style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                ),
                Icon(_open
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded),
              ],
            ),
            AnimatedCrossFade(
              duration: Motion.fast,
              crossFadeState: _open
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox(width: double.infinity),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: Insets.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (e.instructions.isNotEmpty)
                      Text(e.instructions,
                          style: Theme.of(context).textTheme.bodyMedium),
                    if (e.steps.isNotEmpty) ...[
                      const SizedBox(height: Insets.sm),
                      for (final s in e.steps)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            const Text('•  '),
                            Expanded(
                                child: Text(s,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                          ]),
                        ),
                    ],
                    if (e.tips.isNotEmpty) ...[
                      const SizedBox(height: Insets.sm),
                      for (final t in e.tips)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(children: [
                            const Text('💡 '),
                            Expanded(
                                child: Text(t,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                          ]),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
