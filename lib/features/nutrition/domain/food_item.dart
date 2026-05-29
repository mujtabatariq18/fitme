/// A food in the lookup database — backs manual logging and the food-scan
/// fallback when no AI vision provider is configured.
class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.kcalPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.commonServingG = 100,
    this.commonServingLabel = '100 g',
  });

  final String id;
  final String name;
  final String category; // e.g. Protein, Grains, Fruit, Vegetable, Dairy…
  final String emoji;
  final int kcalPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final int commonServingG;
  final String commonServingLabel;

  int kcalForGrams(int grams) => (kcalPer100g * grams / 100).round();
  int get kcalPerServing => kcalForGrams(commonServingG);
}
