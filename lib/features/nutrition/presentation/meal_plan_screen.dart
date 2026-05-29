import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../../onboarding/application/profile_controller.dart';
import '../../onboarding/domain/user_profile.dart';
import '../data/meal_seed.dart';
import '../domain/meal.dart';

class MealPlanScreen extends ConsumerWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final diet = profile.dietType;
    final plans = MealSeed.forDiet(diet);

    return Scaffold(
      appBar: AppBar(title: const Text('Meal Plan')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.sm, Insets.screenH, Insets.huge),
        children: [
          Text('Diet type', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Insets.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final d in MealSeed.supportedDiets)
                  Padding(
                    padding: const EdgeInsets.only(right: Insets.sm),
                    child: _DietChip(
                      label: d.label,
                      selected: d == diet,
                      onTap: () =>
                          ref.read(profileProvider.notifier).setDiet(d),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          for (final day in plans) _DayCard(day: day),
        ],
      ),
    );
  }
}

class _DietChip extends StatelessWidget {
  const _DietChip(
      {required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.lg, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.pink : fit.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: selected ? AppColors.pink : fit.border),
        ),
        child: Text(label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: selected ? Colors.white : fit.textPrimary,
                fontSize: 14)),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.day});
  final DayMealPlan day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.lg),
      child: FitCard(
        padding: EdgeInsets.zero,
        clip: true,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Insets.lg, vertical: Insets.md),
              decoration: const BoxDecoration(gradient: AppGradients.brand),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Day ${day.day}',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: Colors.white)),
                  Text('${day.totalKcal} kcal',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Insets.md),
              child: Column(
                children: [
                  for (final meal in day.meals) _MealRow(meal: meal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MealRow extends StatelessWidget {
  const _MealRow({required this.meal});
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showMeal(context, meal),
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.pinkTint,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              alignment: Alignment.center,
              child: Text(meal.emoji, style: const TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(meal.type.label,
                      style: Theme.of(context).textTheme.labelMedium),
                  Text(meal.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            Text('${meal.kcal} kcal',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.pink)),
          ],
        ),
      ),
    );
  }
}

void _showMeal(BuildContext context, Meal meal) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      builder: (context, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.all(Insets.xl),
        children: [
          Row(
            children: [
              Text(meal.emoji, style: const TextStyle(fontSize: 40)),
              const SizedBox(width: Insets.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meal.type.label,
                        style: Theme.of(context).textTheme.labelMedium),
                    Text(meal.name,
                        style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Insets.md),
          if (meal.description.isNotEmpty)
            Text(meal.description,
                style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: Insets.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Macro('Calories', '${meal.kcal}', AppColors.deepMagenta),
              _Macro('Protein', '${meal.protein}g', AppColors.pink),
              _Macro('Carbs', '${meal.carbs}g', AppColors.blue),
              _Macro('Fat', '${meal.fat}g', AppColors.calories),
            ],
          ),
          const Divider(height: Insets.xxl),
          if (meal.ingredients.isNotEmpty) ...[
            Text('Ingredients',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Insets.sm),
            for (final i in meal.ingredients)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Text('•  '),
                  Expanded(
                      child: Text(i,
                          style: Theme.of(context).textTheme.bodyMedium)),
                ]),
              ),
            const SizedBox(height: Insets.lg),
          ],
          if (meal.steps.isNotEmpty) ...[
            Text('Method', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: Insets.sm),
            for (var s = 0; s < meal.steps.length; s++)
              Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.pink,
                      child: Text('${s + 1}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12)),
                    ),
                    const SizedBox(width: Insets.sm),
                    Expanded(
                        child: Text(meal.steps[s],
                            style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
          ],
          const SizedBox(height: Insets.md),
          Text('⏱ ${meal.prepMinutes} min prep',
              style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    ),
  );
}

class _Macro extends StatelessWidget {
  const _Macro(this.label, this.value, this.color);
  final String label, value;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: color)),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      );
}
