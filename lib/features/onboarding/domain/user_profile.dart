import 'dart:convert';

enum Gender { female, male, nonBinary }

enum FitnessGoal { loseWeight, maintain, buildMuscle, getToned, improveHealth }

enum ActivityLevel { sedentary, light, moderate, active, athlete }

enum DietType { balanced, keto, vegetarian, vegan, glutenFree, paleo }

enum BodyArea { arms, breasts, belly, butt, legs, back, fullBody }

enum UnitSystem { metric, imperial }

extension GoalLabel on FitnessGoal {
  String get label => switch (this) {
        FitnessGoal.loseWeight => 'Lose weight',
        FitnessGoal.maintain => 'Stay fit',
        FitnessGoal.buildMuscle => 'Build muscle',
        FitnessGoal.getToned => 'Get toned',
        FitnessGoal.improveHealth => 'Improve health',
      };
}

extension ActivityFactor on ActivityLevel {
  /// Multiplier applied to BMR for Total Daily Energy Expenditure.
  double get factor => switch (this) {
        ActivityLevel.sedentary => 1.2,
        ActivityLevel.light => 1.375,
        ActivityLevel.moderate => 1.55,
        ActivityLevel.active => 1.725,
        ActivityLevel.athlete => 1.9,
      };

  String get label => switch (this) {
        ActivityLevel.sedentary => 'Mostly sitting',
        ActivityLevel.light => 'Lightly active',
        ActivityLevel.moderate => 'Moderately active',
        ActivityLevel.active => 'Very active',
        ActivityLevel.athlete => 'Athlete',
      };
}

extension AreaLabel on BodyArea {
  String get label => switch (this) {
        BodyArea.arms => 'Arms',
        BodyArea.breasts => 'Breasts',
        BodyArea.belly => 'Belly',
        BodyArea.butt => 'Butt',
        BodyArea.legs => 'Legs',
        BodyArea.back => 'Back',
        BodyArea.fullBody => 'Full body',
      };
}

extension DietLabel on DietType {
  String get label => switch (this) {
        DietType.balanced => 'Balanced',
        DietType.keto => 'Keto',
        DietType.vegetarian => 'Vegetarian',
        DietType.vegan => 'Vegan',
        DietType.glutenFree => 'Gluten Free',
        DietType.paleo => 'Paleo',
      };
}

/// The single source of truth for the user. Persisted locally and synced to
/// Supabase. Holds raw inputs and exposes derived nutrition targets.
class UserProfile {
  const UserProfile({
    this.name = '',
    this.gender = Gender.female,
    this.birthYear,
    this.heightCm,
    this.currentWeightKg,
    this.targetWeightKg,
    this.goal = FitnessGoal.loseWeight,
    this.activityLevel = ActivityLevel.light,
    this.dietType = DietType.balanced,
    this.problemAreas = const {},
    this.units = UnitSystem.metric,
    this.weeklyRateKg = 0.5,
    this.onboardingComplete = false,
  });

  final String name;
  final Gender gender;
  final int? birthYear;
  final double? heightCm;
  final double? currentWeightKg;
  final double? targetWeightKg;
  final FitnessGoal goal;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final Set<BodyArea> problemAreas;
  final UnitSystem units;
  final double weeklyRateKg; // desired pace of weight change
  final bool onboardingComplete;

  int? get age {
    if (birthYear == null) return null;
    // Approximate; precise DOB handled later. Reference year is build-time safe.
    return 2026 - birthYear!;
  }

  /// Basal Metabolic Rate via Mifflin-St Jeor.
  double? get bmr {
    if (heightCm == null || currentWeightKg == null || age == null) return null;
    final base = 10 * currentWeightKg! + 6.25 * heightCm! - 5 * age!;
    return switch (gender) {
      Gender.male => base + 5,
      Gender.female => base - 161,
      Gender.nonBinary => base - 78, // average of the two offsets
    };
  }

  /// Maintenance calories.
  double? get tdee {
    final b = bmr;
    return b == null ? null : b * activityLevel.factor;
  }

  /// Daily calorie target adjusted for the goal (≈7700 kcal per kg).
  int? get dailyCalorieTarget {
    final t = tdee;
    if (t == null) return null;
    final dailyDelta = (weeklyRateKg * 7700) / 7;
    final adjusted = switch (goal) {
      FitnessGoal.loseWeight => t - dailyDelta,
      FitnessGoal.buildMuscle => t + dailyDelta,
      _ => t,
    };
    return adjusted.clamp(1200, 4000).round();
  }

  /// Macro split in grams (protein/carbs/fat) for the chosen diet + target.
  ({int protein, int carbs, int fat})? get macros {
    final cals = dailyCalorieTarget;
    if (cals == null) return null;
    final (pPct, cPct, fPct) = switch (dietType) {
      DietType.keto => (0.30, 0.05, 0.65),
      DietType.paleo => (0.30, 0.35, 0.35),
      DietType.vegan || DietType.vegetarian => (0.20, 0.55, 0.25),
      _ => (0.30, 0.40, 0.30),
    };
    return (
      protein: (cals * pPct / 4).round(),
      carbs: (cals * cPct / 4).round(),
      fat: (cals * fPct / 9).round(),
    );
  }

  double get weightToGoalKg {
    if (currentWeightKg == null || targetWeightKg == null) return 0;
    return (currentWeightKg! - targetWeightKg!).abs();
  }

  UserProfile copyWith({
    String? name,
    Gender? gender,
    int? birthYear,
    double? heightCm,
    double? currentWeightKg,
    double? targetWeightKg,
    FitnessGoal? goal,
    ActivityLevel? activityLevel,
    DietType? dietType,
    Set<BodyArea>? problemAreas,
    UnitSystem? units,
    double? weeklyRateKg,
    bool? onboardingComplete,
  }) {
    return UserProfile(
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthYear: birthYear ?? this.birthYear,
      heightCm: heightCm ?? this.heightCm,
      currentWeightKg: currentWeightKg ?? this.currentWeightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      goal: goal ?? this.goal,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      problemAreas: problemAreas ?? this.problemAreas,
      units: units ?? this.units,
      weeklyRateKg: weeklyRateKg ?? this.weeklyRateKg,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'gender': gender.name,
        'birthYear': birthYear,
        'heightCm': heightCm,
        'currentWeightKg': currentWeightKg,
        'targetWeightKg': targetWeightKg,
        'goal': goal.name,
        'activityLevel': activityLevel.name,
        'dietType': dietType.name,
        'problemAreas': problemAreas.map((e) => e.name).toList(),
        'units': units.name,
        'weeklyRateKg': weeklyRateKg,
        'onboardingComplete': onboardingComplete,
      };

  factory UserProfile.fromMap(Map<String, dynamic> m) => UserProfile(
        name: m['name'] ?? '',
        gender: Gender.values.byName(m['gender'] ?? 'female'),
        birthYear: m['birthYear'],
        heightCm: (m['heightCm'] as num?)?.toDouble(),
        currentWeightKg: (m['currentWeightKg'] as num?)?.toDouble(),
        targetWeightKg: (m['targetWeightKg'] as num?)?.toDouble(),
        goal: FitnessGoal.values.byName(m['goal'] ?? 'loseWeight'),
        activityLevel:
            ActivityLevel.values.byName(m['activityLevel'] ?? 'light'),
        dietType: DietType.values.byName(m['dietType'] ?? 'balanced'),
        problemAreas: ((m['problemAreas'] as List?) ?? [])
            .map((e) => BodyArea.values.byName(e))
            .toSet(),
        units: UnitSystem.values.byName(m['units'] ?? 'metric'),
        weeklyRateKg: (m['weeklyRateKg'] as num?)?.toDouble() ?? 0.5,
        onboardingComplete: m['onboardingComplete'] ?? false,
      );

  String toJson() => jsonEncode(toMap());
  factory UserProfile.fromJson(String s) =>
      UserProfile.fromMap(jsonDecode(s) as Map<String, dynamic>);
}
