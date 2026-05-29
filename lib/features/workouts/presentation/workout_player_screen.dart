import 'dart:async';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/exercise.dart';
import 'exercise_avatar.dart';

/// Full-screen guided workout player that steps through each exercise in a
/// [WorkoutRoutine], displays an animated avatar, manages set/rest countdowns,
/// and shows a completion summary on finish.
class WorkoutPlayerScreen extends StatefulWidget {
  const WorkoutPlayerScreen({
    super.key,
    required this.routine,
    this.isMale = false,
  });

  final WorkoutRoutine routine;
  final bool isMale;

  @override
  State<WorkoutPlayerScreen> createState() => _WorkoutPlayerScreenState();
}

// ── Player phases ─────────────────────────────────────────────────────────────
enum _Phase { exercise, rest, done }

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  // Navigation state
  int _exerciseIndex = 0;
  int _currentSet = 1; // 1-based
  _Phase _phase = _Phase.exercise;
  bool _paused = false;

  // Countdown state (timed exercises & rest)
  Timer? _timer;
  int _countdown = 0;

  // Completion tracking
  int _totalSetsCompleted = 0;

  // ── Helpers ────────────────────────────────────────────────────────────────
  List<Exercise> get _exercises => widget.routine.exercises;
  Exercise get _current => _exercises[_exerciseIndex];

  /// Total sets across the whole routine for the progress bar.
  int get _totalSets =>
      _exercises.fold(0, (sum, e) => sum + e.sets);

  @override
  void initState() {
    super.initState();
    _startPhase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ── Phase management ───────────────────────────────────────────────────────
  void _startPhase() {
    _timer?.cancel();
    if (_phase == _Phase.exercise && _current.isTimed) {
      _countdown = _current.durationSec!;
      _startCountdown(onComplete: _onExerciseCountdownDone);
    } else if (_phase == _Phase.rest) {
      _countdown = _current.restSec;
      _startCountdown(onComplete: _onRestDone);
    }
    // rep-based exercises wait for user tap
  }

  void _startCountdown({required VoidCallback onComplete}) {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_paused) return;
      if (_countdown <= 1) {
        t.cancel();
        onComplete();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _onExerciseCountdownDone() {
    setState(() {});
    _advanceSet();
  }

  void _onRestDone() {
    setState(() => _phase = _Phase.exercise);
    _startPhase();
  }

  /// Called after a set is "done" (either by countdown or tap).
  void _advanceSet() {
    _timer?.cancel();
    _totalSetsCompleted++;

    if (_currentSet < _current.sets) {
      // More sets for this exercise → rest
      setState(() {
        _currentSet++;
        _phase = _Phase.rest;
      });
      _startPhase();
    } else {
      // All sets done → move to next exercise or finish
      if (_exerciseIndex < _exercises.length - 1) {
        setState(() {
          _exerciseIndex++;
          _currentSet = 1;
          _phase = _Phase.rest; // brief rest between exercises too
          _countdown = _current.restSec; // now _current = new exercise
        });
        _startPhase();
      } else {
        setState(() => _phase = _Phase.done);
      }
    }
  }

  void _togglePause() {
    setState(() => _paused = !_paused);
  }

  void _skip() {
    _timer?.cancel();
    if (_phase == _Phase.rest) {
      _onRestDone();
    } else {
      _advanceSet();
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.done) {
      return _DoneScreen(
        routine: widget.routine,
        setsCompleted: _totalSetsCompleted,
      );
    }

    final theme = Theme.of(context);
    final isResting = _phase == _Phase.rest;

    return Scaffold(
      backgroundColor: AppColors.night0,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              routineName: widget.routine.name,
              onClose: () => Navigator.of(context).pop(),
            ),
            _ProgressBar(
              completed: _totalSetsCompleted,
              total: _totalSets,
            ),
            const SizedBox(height: Insets.lg),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
                child: Column(
                  children: [
                    if (isResting)
                      _RestCard(countdown: _countdown)
                    else ...[
                      // Avatar
                      ExerciseAvatar(
                        isMale: widget.isMale,
                        size: 200,
                        animating: !_paused,
                      ),
                      const SizedBox(height: Insets.lg),
                      // Exercise emoji + name
                      Text(
                        _current.emoji,
                        style: const TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: Insets.sm),
                      Text(
                        _current.name,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: Insets.xs),
                      // Set counter
                      _SetBadge(
                        current: _currentSet,
                        total: _current.sets,
                        volumeLabel: _current.volumeLabel,
                      ),
                      const SizedBox(height: Insets.xl),
                      // Timed countdown OR rep indicator
                      if (_current.isTimed)
                        _CircularCountdown(
                          countdown: _countdown,
                          total: _current.durationSec!,
                        )
                      else
                        _RepIndicator(reps: _current.reps),
                      const SizedBox(height: Insets.xxl),
                      // Instructions
                      _InstructionCard(exercise: _current),
                    ],
                    const SizedBox(height: Insets.xxl),
                  ],
                ),
              ),
            ),
            // Controls
            _ControlBar(
              phase: _phase,
              paused: _paused,
              isTimed: _phase == _Phase.exercise && _current.isTimed,
              onPause: _togglePause,
              onSkip: _skip,
              onDoneSet: (_phase == _Phase.exercise && !_current.isTimed)
                  ? _advanceSet
                  : null,
            ),
            const SizedBox(height: Insets.lg),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({required this.routineName, required this.onClose});

  final String routineName;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
      child: Row(
        children: [
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close_rounded,
                color: AppColors.ink300, size: 26),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Text(
              routineName,
              style: const TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.completed, required this.total});

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (completed / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.night3,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.pink),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$completed / $total sets',
            style: const TextStyle(
              color: AppColors.ink300,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetBadge extends StatelessWidget {
  const _SetBadge({
    required this.current,
    required this.total,
    required this.volumeLabel,
  });

  final int current;
  final int total;
  final String volumeLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg, vertical: Insets.xs),
          decoration: BoxDecoration(
            gradient: AppGradients.brand,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          child: Text(
            'Set $current / $total',
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: Insets.md),
        Text(
          volumeLabel,
          style: const TextStyle(
            color: AppColors.ink300,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _CircularCountdown extends StatelessWidget {
  const _CircularCountdown({required this.countdown, required this.total});

  final int countdown;
  final int total;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : (countdown / total).clamp(0.0, 1.0);
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: AppColors.night3,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.pink),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$countdown',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 40,
                ),
              ),
              const Text(
                's',
                style: TextStyle(
                  color: AppColors.ink300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RepIndicator extends StatelessWidget {
  const _RepIndicator({required this.reps});

  final int reps;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$reps',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: 64,
          ),
        ),
        const Text(
          'REPS',
          style: TextStyle(
            color: AppColors.ink300,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }
}

class _RestCard extends StatelessWidget {
  const _RestCard({required this.countdown});

  final int countdown;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: Insets.huge),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Insets.xxl),
          decoration: BoxDecoration(
            color: AppColors.night2,
            borderRadius: Radii.cardRadius,
            border: Border.all(color: AppColors.night3),
          ),
          child: Column(
            children: [
              const Icon(Icons.self_improvement_rounded,
                  color: AppColors.pink, size: 48),
              const SizedBox(height: Insets.lg),
              const Text(
                'REST',
                style: TextStyle(
                  color: AppColors.ink300,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: Insets.sm),
              Text(
                '$countdown',
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 72,
                ),
              ),
              const Text(
                'seconds',
                style: TextStyle(color: AppColors.ink300, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstructionCard extends StatelessWidget {
  const _InstructionCard({required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.night2,
        borderRadius: Radii.cardRadius,
        border: Border.all(color: AppColors.night3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Instructions',
            style: TextStyle(
              color: AppColors.pink,
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: Insets.sm),
          Text(
            exercise.instructions.isNotEmpty
                ? exercise.instructions
                : 'Perform the exercise with controlled form.',
            style: const TextStyle(
              color: AppColors.ink300,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          if (exercise.tips.isNotEmpty) ...[
            const SizedBox(height: Insets.md),
            const Text(
              'Tips',
              style: TextStyle(
                color: AppColors.pinkBright,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: Insets.xs),
            ...exercise.tips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: Insets.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(
                            color: AppColors.pink, fontWeight: FontWeight.w700)),
                    Expanded(
                      child: Text(
                        tip,
                        style: const TextStyle(
                            color: AppColors.ink300, fontSize: 13, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ControlBar extends StatelessWidget {
  const _ControlBar({
    required this.phase,
    required this.paused,
    required this.isTimed,
    required this.onPause,
    required this.onSkip,
    this.onDoneSet,
  });

  final _Phase phase;
  final bool paused;
  final bool isTimed;
  final VoidCallback onPause;
  final VoidCallback onSkip;
  final VoidCallback? onDoneSet;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        children: [
          if (onDoneSet != null) ...[
            PrimaryButton(
              label: 'Done Set',
              onPressed: onDoneSet,
              icon: Icons.check_rounded,
            ),
            const SizedBox(height: Insets.md),
          ],
          Row(
            children: [
              Expanded(
                child: _IconTextButton(
                  icon: paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  label: paused ? 'Resume' : 'Pause',
                  onTap: onPause,
                ),
              ),
              const SizedBox(width: Insets.md),
              Expanded(
                child: _IconTextButton(
                  icon: Icons.skip_next_rounded,
                  label: phase == _Phase.rest ? 'Skip Rest' : 'Skip',
                  onTap: onSkip,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconTextButton extends StatelessWidget {
  const _IconTextButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.night2,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: AppColors.night3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.ink300, size: 20),
            const SizedBox(width: Insets.xs),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.ink300,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Done / Completion screen
// ─────────────────────────────────────────────────────────────────────────────

class _DoneScreen extends StatelessWidget {
  const _DoneScreen({
    required this.routine,
    required this.setsCompleted,
  });

  final WorkoutRoutine routine;
  final int setsCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.night0,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Insets.screenH),
          child: Column(
            children: [
              const Spacer(),
              // Trophy icon with glow
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.brand,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withValues(alpha: 0.4),
                      blurRadius: 32,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(Icons.emoji_events_rounded,
                    color: AppColors.white, size: 52),
              ),
              const SizedBox(height: Insets.xxl),
              Text(
                'Workout Complete!',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Insets.sm),
              Text(
                routine.name,
                style: const TextStyle(
                  color: AppColors.ink300,
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Insets.xxl),
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(Insets.xxl),
                decoration: BoxDecoration(
                  color: AppColors.night2,
                  borderRadius: Radii.cardRadius,
                  border: Border.all(color: AppColors.night3),
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      icon: Icons.fitness_center_rounded,
                      label: 'Exercises',
                      value: '${routine.exerciseCount}',
                    ),
                    const SizedBox(height: Insets.lg),
                    _SummaryRow(
                      icon: Icons.local_fire_department_rounded,
                      label: 'Est. Calories',
                      value: '${routine.estKcal} kcal',
                      accent: AppColors.calories,
                    ),
                    const SizedBox(height: Insets.lg),
                    _SummaryRow(
                      icon: Icons.timer_outlined,
                      label: 'Duration',
                      value: '~${routine.durationMin} min',
                      accent: AppColors.blue,
                    ),
                    const SizedBox(height: Insets.lg),
                    _SummaryRow(
                      icon: Icons.repeat_rounded,
                      label: 'Sets Done',
                      value: '$setsCompleted',
                      accent: AppColors.success,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Finish',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.check_circle_outline_rounded,
              ),
              const SizedBox(height: Insets.md),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = AppColors.pink,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(width: Insets.md),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.ink300,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
