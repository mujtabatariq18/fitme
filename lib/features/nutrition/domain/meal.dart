import '../../onboarding/domain/user_profile.dart';

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabel on MealType {
  String get label => switch (this) {
        MealType.breakfast => 'Breakfast',
        MealType.lunch => 'Lunch',
        MealType.dinner => 'Dinner',
        MealType.snack => 'Snack',
      };

  String get emoji => switch (this) {
        MealType.breakfast => '🍳',
        MealType.lunch => '🥗',
        MealType.dinner => '🍲',
        MealType.snack => '🍎',
      };
}

/// A single recipe/meal with full nutrition and prep info.
class Meal {
  const Meal({
    required this.id,
    required this.name,
    required this.type,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.emoji,
    this.description = '',
    this.ingredients = const [],
    this.steps = const [],
    this.prepMinutes = 10,
    this.diets = const [],
  });

  final String id;
  final String name;
  final MealType type;
  final int kcal;
  final int protein; // grams
  final int carbs;
  final int fat;
  final String emoji;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final int prepMinutes;
  final List<DietType> diets;

  bool fitsDiet(DietType d) => diets.isEmpty || diets.contains(d);
}

/// One day of a meal plan.
class DayMealPlan {
  const DayMealPlan({required this.day, required this.meals});
  final int day;
  final List<Meal> meals;

  int get totalKcal => meals.fold(0, (s, m) => s + m.kcal);
  int get totalProtein => meals.fold(0, (s, m) => s + m.protein);
  int get totalCarbs => meals.fold(0, (s, m) => s + m.carbs);
  int get totalFat => meals.fold(0, (s, m) => s + m.fat);
}
