import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/exercise.dart';
import 'exercise_demo.dart';

enum _Phase { go, rest, done }

/// Gamified workout session. Once started it only asks "is this set done?",
/// drives a big progress meter, and awards XP + combo for completed sets.
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

class _WorkoutPlayerScreenState extends State<WorkoutPlayerScreen> {
  int _exIndex = 0;
  int _set = 1;
  int _completed = 0;
  int _skipped = 0;
  int _score = 0;
  int _combo = 0;
  _Phase _phase = _Phase.go;

  Timer? _restTimer;
  int _restLeft = 0;
  String _flash = '';

  late final int _totalSets =
      widget.routine.exercises.fold(0, (s, e) => s + e.sets);

  Exercise get _ex => widget.routine.exercises[_exIndex];
  double get _progress => _totalSets == 0 ? 0 : _completed / _totalSets;

  @override
  void dispose() {
    _restTimer?.cancel();
    super.dispose();
  }

  bool get _isLastSetOfAll =>
      _exIndex == widget.routine.exercises.length - 1 && _set == _ex.sets;

  void _setDone() {
    _combo++;
    final gained = 10 + (_combo >= 3 ? 5 : 0) + (_ex.isTimed ? 2 : 0);
    setState(() {
      _completed++;
      _score += gained;
      _flash = '+$gained XP${_combo >= 3 ? '  🔥x$_combo' : ''}';
    });
    _afterSet();
  }

  void _skipSet() {
    setState(() {
      _completed++;
      _skipped++;
      _combo = 0;
      _flash = 'skipped';
    });
    _afterSet();
  }

  void _afterSet() {
    final restSec = _ex.restSec.clamp(10, 90);
    if (_isLastSetOfAll) {
      setState(() => _phase = _Phase.done);
      return;
    }
    // Advance pointers to the next set / exercise.
    if (_set < _ex.sets) {
      _set++;
    } else {
      _exIndex++;
      _set = 1;
    }
    _startRest(restSec);
  }

  void _startRest(int seconds) {
    _restTimer?.cancel();
    setState(() {
      _phase = _Phase.rest;
      _restLeft = seconds;
    });
    _restTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_restLeft <= 1) {
        t.cancel();
        setState(() => _phase = _Phase.go);
      } else {
        setState(() => _restLeft--);
      }
    });
  }

  void _skipRest() {
    _restTimer?.cancel();
    setState(() => _phase = _Phase.go);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.fit.background,
      body: SafeArea(
        child: _phase == _Phase.done
            ? _Summary(
                routine: widget.routine,
                score: _score,
                completed: _completed,
                skipped: _skipped,
                onFinish: () => Navigator.of(context).pop(),
              )
            : Column(
                children: [
                  _Header(
                    title: widget.routine.name,
                    score: _score,
                    onClose: () => Navigator.of(context).maybePop(),
                  ),
                  _Meter(
                      progress: _progress,
                      completed: _completed,
                      total: _totalSets),
                  Expanded(
                    child: _phase == _Phase.go ? _buildGo() : _buildRest(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGo() {
    final e = _ex;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        children: [
          const Spacer(),
          ExerciseDemo(
              exerciseName: e.name, isMale: widget.isMale, size: 260),
          const SizedBox(height: Insets.lg),
          Text(e.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: Insets.xs),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.pinkTint,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: Text(
              'Set $_set of ${e.sets}  ·  ${e.isTimed ? "hold ${e.durationSec}s" : "${e.reps} reps"}',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: AppColors.deepMagenta),
            ),
          ),
          if (_flash.isNotEmpty) ...[
            const SizedBox(height: Insets.sm),
            Text(_flash,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.success)),
          ],
          const Spacer(),
          PrimaryButton(
            label: 'Set done',
            icon: Icons.check_rounded,
            onPressed: _setDone,
          ),
          TextButton(
            onPressed: _skipSet,
            child: Text('Skip set',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: context.fit.textTertiary)),
          ),
          const SizedBox(height: Insets.sm),
        ],
      ),
    );
  }

  Widget _buildRest() {
    final next = _ex;
    final restBase = _ex.restSec.clamp(10, 90);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('REST',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.blue, letterSpacing: 2)),
          const SizedBox(height: Insets.lg),
          SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: restBase == 0 ? 0 : _restLeft / restBase,
                    strokeWidth: 10,
                    backgroundColor: AppColors.blueTint,
                    valueColor: const AlwaysStoppedAnimation(AppColors.blue),
                  ),
                ),
                Text('$_restLeft',
                    style: Theme.of(context).textTheme.displayLarge),
              ],
            ),
          ),
          const SizedBox(height: Insets.xl),
          Text('Up next', style: Theme.of(context).textTheme.labelMedium),
          Text('${next.name} · Set $_set of ${next.sets}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Insets.xl),
          SecondaryButton(label: 'Skip rest', onPressed: _skipRest),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(
      {required this.title, required this.score, required this.onClose});
  final String title;
  final int score;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Insets.sm, Insets.sm, Insets.lg, 0),
      child: Row(
        children: [
          IconButton(
              onPressed: onClose, icon: const Icon(Icons.close_rounded)),
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: Insets.md, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppGradients.brand,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: Text('⭐ $score XP',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

/// The progress meter — the spine of the gamified session.
class _Meter extends StatelessWidget {
  const _Meter(
      {required this.progress, required this.completed, required this.total});
  final double progress;
  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Insets.screenH, Insets.sm, Insets.screenH, Insets.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$completed / $total sets',
                  style: Theme.of(context).textTheme.labelLarge),
              Text('${(progress * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: AppColors.pink)),
            ],
          ),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, c) => Stack(
              children: [
                Container(
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.pinkTint,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress.clamp(0, 1)),
                  duration: Motion.base,
                  curve: Motion.emphasized,
                  builder: (_, v, _) => Container(
                    height: 14,
                    width: c.maxWidth * v,
                    decoration: BoxDecoration(
                      gradient: AppGradients.brand,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({
    required this.routine,
    required this.score,
    required this.completed,
    required this.skipped,
    required this.onFinish,
  });
  final WorkoutRoutine routine;
  final int score;
  final int completed;
  final int skipped;
  final VoidCallback onFinish;

  int get _stars => skipped == 0 ? 3 : (skipped <= 2 ? 2 : 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
                gradient: AppGradients.brand, shape: BoxShape.circle),
            child: const Icon(Icons.emoji_events_rounded,
                color: Colors.white, size: 52),
          ),
          const SizedBox(height: Insets.lg),
          Text('Workout complete!',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: Insets.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (i) => Icon(
                      i < _stars
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: AppColors.warning,
                      size: 40,
                    )),
          ),
          const SizedBox(height: Insets.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _stat(context, '⭐', '$score', 'XP earned'),
              _stat(context, '✅', '$completed', 'sets done'),
              _stat(context, '🔥', '${routine.estKcal}', 'kcal'),
            ],
          ),
          const SizedBox(height: Insets.xxxl),
          PrimaryButton(label: 'Finish', onPressed: onFinish),
        ],
      ),
    );
  }

  Widget _stat(BuildContext c, String emoji, String value, String label) =>
      Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          Text(value, style: Theme.of(c).textTheme.titleLarge),
          Text(label, style: Theme.of(c).textTheme.labelMedium),
        ],
      );
}
