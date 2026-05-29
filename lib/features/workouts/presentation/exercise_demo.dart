import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'exercise_avatar.dart';

/// Resolves a free-form exercise name to a locally-hosted demo slug.
/// Demos are two correct-form frames (start/end) from the open-license
/// free-exercise-db, alternated to animate the movement.
class ExerciseDemoResolver {
  ExerciseDemoResolver._();

  // Ordered: most specific first. All keywords must appear in the name.
  static const _rules = <(List<String>, String)>[
    (['diamond'], 'diamond_pushup'),
    (['tricep', 'kickback'], 'tricep_kickback'),
    (['tricep', 'dip'], 'bench_dip'),
    (['tricep'], 'tricep_extension'),
    (['overhead'], 'tricep_extension'),
    (['push'], 'pushup'),
    (['goblet'], 'goblet_squat'),
    (['sumo'], 'sumo_squat'),
    (['split'], 'lunge'),
    (['wall', 'sit'], 'squat'),
    (['jump', 'squat'], 'squat'),
    (['squat'], 'squat'),
    (['side', 'plank'], 'side_plank'),
    (['plank'], 'plank'),
    (['walking', 'lunge'], 'walking_lunge'),
    (['curtsy'], 'lunge'),
    (['lunge'], 'lunge'),
    (['hamstring'], 'glute_bridge'),
    (['hip', 'thrust'], 'glute_bridge'),
    (['bridge'], 'glute_bridge'),
    (['donkey'], 'glute_kickback'),
    (['clamshell'], 'glute_kickback'),
    (['kickback'], 'glute_kickback'),
    (['dip'], 'bench_dip'),
    (['hammer'], 'hammer_curl'),
    (['bicep'], 'bicep_curl'),
    (['curl'], 'bicep_curl'),
    (['russian'], 'russian_twist'),
    (['bicycle'], 'crunch'),
    (['dead', 'bug'], 'crunch'),
    (['knee', 'tuck'], 'crunch'),
    (['crunch'], 'crunch'),
    (['leg', 'raise'], 'leg_raise'),
    (['mountain'], 'mountain_climber'),
    (['superman'], 'superman'),
    (['calf'], 'calf_raise'),
    (['reverse', 'fly'], 'reverse_fly'),
    (['face', 'pull'], 'face_pull'),
    (['y-t-w'], 'face_pull'),
    (['lat', 'pull'], 'face_pull'),
    (['fly'], 'chest_fly'),
    (['chest'], 'chest_press'),
    (['press'], 'chest_press'),
    (['single-arm', 'row'], 'one_arm_row'),
    (['row'], 'row'),
    (['romanian'], 'romanian_deadlift'),
    (['deadlift'], 'romanian_deadlift'),
    (['good', 'morning'], 'good_morning'),
    (['cat'], 'cat_cow'),
    (['child'], 'cat_cow'),
    (['bird'], 'cat_cow'),
  ];

  static String? slugFor(String name) {
    final n = name.toLowerCase();
    for (final (keywords, slug) in _rules) {
      if (keywords.every(n.contains)) return slug;
    }
    return null;
  }
}

/// Animated, correct-form exercise demonstration. Cross-fades between the
/// start and end frames to show the movement; falls back to the vector
/// [ExerciseAvatar] when there's no matching demo.
class ExerciseDemo extends StatefulWidget {
  const ExerciseDemo({
    super.key,
    required this.exerciseName,
    this.isMale = false,
    this.size = 240,
    this.animating = true,
  });

  final String exerciseName;
  final bool isMale;
  final double size;
  final bool animating;

  @override
  State<ExerciseDemo> createState() => _ExerciseDemoState();
}

class _ExerciseDemoState extends State<ExerciseDemo> {
  Timer? _timer;
  bool _second = false;
  late final String? _slug = ExerciseDemoResolver.slugFor(widget.exerciseName);

  @override
  void initState() {
    super.initState();
    if (_slug != null && widget.animating) {
      _timer = Timer.periodic(const Duration(milliseconds: 850), (_) {
        if (mounted) setState(() => _second = !_second);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_slug == null) {
      // No demo image — use the vector avatar as a graceful fallback.
      return ExerciseAvatar(
          isMale: widget.isMale, size: widget.size, animating: widget.animating);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radii.lg),
      child: Container(
        width: widget.size,
        height: widget.size,
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 350),
              firstChild: _frame(0),
              secondChild: _frame(1),
              crossFadeState:
                  _second ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            ),
            Positioned(
              top: Insets.sm,
              left: Insets.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.deepMagenta.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
                child: const Text('CORRECT FORM',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _frame(int i) => Image.asset(
        'assets/exercises/${_slug}_$i.jpg',
        fit: BoxFit.cover,
        gaplessPlayback: true,
        errorBuilder: (_, _, _) => ExerciseAvatar(
            isMale: widget.isMale, size: widget.size, animating: false),
      );
}
