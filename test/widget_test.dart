import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitme/features/onboarding/domain/user_profile.dart';

void main() {
  group('UserProfile nutrition math', () {
    test('computes BMR/TDEE and a calorie deficit for weight loss', () {
      const p = UserProfile(
        gender: Gender.female,
        birthYear: 1998, // ~28 in 2026
        heightCm: 165,
        currentWeightKg: 70,
        targetWeightKg: 62,
        goal: FitnessGoal.loseWeight,
        activityLevel: ActivityLevel.light,
        weeklyRateKg: 0.5,
      );

      expect(p.bmr, isNotNull);
      expect(p.tdee, greaterThan(p.bmr!));
      // Losing weight => target below maintenance.
      expect(p.dailyCalorieTarget!, lessThan(p.tdee!.round()));
      expect(p.weightToGoalKg, closeTo(8, 0.01));
    });

    test('macros split sums to a plausible calorie total', () {
      const p = UserProfile(
        gender: Gender.male,
        birthYear: 1995,
        heightCm: 180,
        currentWeightKg: 82,
        targetWeightKg: 82,
        goal: FitnessGoal.maintain,
        dietType: DietType.balanced,
      );
      final m = p.macros!;
      final kcal = m.protein * 4 + m.carbs * 4 + m.fat * 9;
      expect(kcal, closeTo(p.dailyCalorieTarget!, 60));
    });

    test('round-trips through JSON', () {
      const p = UserProfile(name: 'Sam', problemAreas: {BodyArea.belly});
      final restored = UserProfile.fromJson(p.toJson());
      expect(restored.name, 'Sam');
      expect(restored.problemAreas, contains(BodyArea.belly));
    });
  });

  testWidgets('smoke: MaterialApp builds', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold()));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
