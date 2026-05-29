import '../../onboarding/domain/user_profile.dart';

enum TipCategory { nutrition, training, recovery, mindset, hydration }

extension TipCategoryMeta on TipCategory {
  String get label => switch (this) {
        TipCategory.nutrition => 'Nutrition',
        TipCategory.training => 'Training',
        TipCategory.recovery => 'Recovery',
        TipCategory.mindset => 'Mindset',
        TipCategory.hydration => 'Hydration',
      };

  String get emoji => switch (this) {
        TipCategory.nutrition => '🥦',
        TipCategory.training => '💪',
        TipCategory.recovery => '😴',
        TipCategory.mindset => '🧠',
        TipCategory.hydration => '💧',
      };
}

/// A coaching tip. [forGoal] null = applies to everyone.
class CoachTip {
  const CoachTip({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    this.forGoal,
  });

  final String id;
  final String title;
  final String body;
  final TipCategory category;
  final FitnessGoal? forGoal;
}

/// A canned conversation starter / FAQ the coach can answer offline.
class CoachPrompt {
  const CoachPrompt({required this.question, required this.answer});
  final String question;
  final String answer;
}
