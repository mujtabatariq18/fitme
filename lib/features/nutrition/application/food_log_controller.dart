import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/local_store.dart';
import '../domain/food_item.dart';
import '../domain/meal.dart';

class FoodLogEntry {
  const FoodLogEntry({
    required this.id,
    required this.name,
    required this.emoji,
    required this.kcal,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.meal,
  });

  final String id;
  final String name;
  final String emoji;
  final int kcal;
  final int protein;
  final int carbs;
  final int fat;
  final MealType meal;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'kcal': kcal,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'meal': meal.name,
      };

  factory FoodLogEntry.fromMap(Map<String, dynamic> m) => FoodLogEntry(
        id: m['id'],
        name: m['name'],
        emoji: m['emoji'] ?? '🍽️',
        kcal: m['kcal'],
        protein: m['protein'] ?? 0,
        carbs: m['carbs'] ?? 0,
        fat: m['fat'] ?? 0,
        meal: MealType.values.byName(m['meal'] ?? 'snack'),
      );
}

/// Today's food log. (Day rollover handled in a later phase; for now it's the
/// running "today" list, persisted locally.)
class FoodLogController extends Notifier<List<FoodLogEntry>> {
  late final LocalStore _store;
  int _seq = 0;

  @override
  List<FoodLogEntry> build() {
    _store = ref.read(localStoreProvider);
    final raw = _store.getFoodLog();
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List)
          .map((e) => FoodLogEntry.fromMap(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  void _persist() =>
      _store.setFoodLog(jsonEncode(state.map((e) => e.toMap()).toList()));

  void addFromFood(FoodItem food, int grams, MealType meal) {
    _seq++;
    final entry = FoodLogEntry(
      id: 'log_${state.length}_$_seq',
      name: food.name,
      emoji: food.emoji,
      kcal: food.kcalForGrams(grams),
      protein: (food.proteinPer100g * grams / 100).round(),
      carbs: (food.carbsPer100g * grams / 100).round(),
      fat: (food.fatPer100g * grams / 100).round(),
      meal: meal,
    );
    state = [...state, entry];
    _persist();
  }

  void addCustom({
    required String name,
    required int kcal,
    int protein = 0,
    int carbs = 0,
    int fat = 0,
    MealType meal = MealType.snack,
    String emoji = '🍽️',
  }) {
    _seq++;
    state = [
      ...state,
      FoodLogEntry(
        id: 'log_${state.length}_$_seq',
        name: name,
        emoji: emoji,
        kcal: kcal,
        protein: protein,
        carbs: carbs,
        fat: fat,
        meal: meal,
      ),
    ];
    _persist();
  }

  void remove(String id) {
    state = state.where((e) => e.id != id).toList();
    _persist();
  }

  void clearDay() {
    state = [];
    _persist();
  }

  int get totalKcal => state.fold(0, (s, e) => s + e.kcal);
  int get totalProtein => state.fold(0, (s, e) => s + e.protein);
  int get totalCarbs => state.fold(0, (s, e) => s + e.carbs);
  int get totalFat => state.fold(0, (s, e) => s + e.fat);
}

final foodLogProvider =
    NotifierProvider<FoodLogController, List<FoodLogEntry>>(
        FoodLogController.new);
