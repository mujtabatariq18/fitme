import '../../onboarding/domain/user_profile.dart';

enum Difficulty { beginner, intermediate, advanced }

extension DifficultyLabel on Difficulty {
  String get label => switch (this) {
        Difficulty.beginner => 'Beginner',
        Difficulty.intermediate => 'Intermediate',
        Difficulty.advanced => 'Advanced',
      };
}

/// A single exercise with coaching cues.
class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.target,
    required this.emoji,
    this.sets = 3,
    this.reps = 12,
    this.durationSec,
    this.restSec = 30,
    this.instructions = '',
    this.steps = const [],
    this.tips = const [],
    this.equipment = 'None',
    this.kcalPerSet = 8,
  });

  final String id;
  final String name;
  final BodyArea target;
  final String emoji;
  final int sets;
  final int reps;
  final int? durationSec; // for timed holds (e.g. plank)
  final int restSec;
  final String instructions;
  final List<String> steps;
  final List<String> tips;
  final String equipment;
  final int kcalPerSet;

  bool get isTimed => durationSec != null;
  int get estKcal => kcalPerSet * sets;

  String get volumeLabel =>
      isTimed ? '$sets × ${durationSec}s' : '$sets × $reps reps';
}

/// A complete routine targeting an area at a difficulty level.
class WorkoutRoutine {
  const WorkoutRoutine({
    required this.id,
    required this.name,
    required this.area,
    required this.difficulty,
    required this.exercises,
    this.focus = '',
    this.emoji = '🔥',
  });

  final String id;
  final String name;
  final BodyArea area;
  final Difficulty difficulty;
  final List<Exercise> exercises;
  final String focus;
  final String emoji;

  int get durationMin {
    var sec = 0;
    for (final e in exercises) {
      sec += (e.durationSec ?? e.reps * 3) * e.sets + e.restSec * e.sets;
    }
    return (sec / 60).ceil();
  }

  int get estKcal => exercises.fold(0, (s, e) => s + e.estKcal);
  int get exerciseCount => exercises.length;
}
