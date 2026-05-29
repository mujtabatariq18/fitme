import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/fit_card.dart';
import '../../../core/widgets/metric_ring.dart';
import '../../admin/application/ai_config_controller.dart';
import '../../admin/domain/ai_provider_config.dart';
import '../../onboarding/application/profile_controller.dart';
import '../application/food_log_controller.dart';
import '../data/food_seed.dart';
import '../domain/food_item.dart';
import '../domain/meal.dart';

class FoodLogScreen extends ConsumerWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(foodLogProvider);
    final log = ref.read(foodLogProvider.notifier);
    final target = ref.watch(profileProvider).dailyCalorieTarget ?? 2000;
    final consumed = log.totalKcal;

    return Scaffold(
      appBar: AppBar(title: const Text('Food Log')),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add food'),
        onPressed: () => _openFoodPicker(context, ref),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
            Insets.screenH, Insets.sm, Insets.screenH, 96),
        children: [
          FitCard(
            child: Row(
              children: [
                MetricRing(
                  progress: consumed / target,
                  color: AppColors.pink,
                  size: 96,
                  strokeWidth: 9,
                  center: Text('${((consumed / target) * 100).round()}%',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(width: Insets.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$consumed / $target kcal',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('${(target - consumed).clamp(0, target)} kcal left',
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: Insets.sm),
                      Row(children: [
                        _m(context, 'P', log.totalProtein, AppColors.pink),
                        _m(context, 'C', log.totalCarbs, AppColors.blue),
                        _m(context, 'F', log.totalFat, AppColors.calories),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Insets.md),
          _ScanCard(),
          const SizedBox(height: Insets.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Today's log",
                  style: Theme.of(context).textTheme.titleLarge),
              if (entries.isNotEmpty)
                TextButton(
                    onPressed: log.clearDay, child: const Text('Clear')),
            ],
          ),
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.all(Insets.xl),
              child: Center(
                child: Text('Nothing logged yet — tap “Add food”.',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          for (final e in entries)
            Dismissible(
              key: ValueKey(e.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => log.remove(e.id),
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: Insets.lg),
                color: AppColors.danger,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: FitCard(
                  padding: const EdgeInsets.all(Insets.md),
                  child: Row(
                    children: [
                      Text(e.emoji, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: Insets.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.name,
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                            Text(e.meal.label,
                                style:
                                    Theme.of(context).textTheme.labelMedium),
                          ],
                        ),
                      ),
                      Text('${e.kcal} kcal',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: AppColors.pink)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _m(BuildContext c, String k, int g, Color col) => Padding(
        padding: const EdgeInsets.only(right: Insets.md),
        child: Text('$k ${g}g',
            style: Theme.of(c)
                .textTheme
                .labelMedium
                ?.copyWith(color: col, fontWeight: FontWeight.w700)),
      );

  void _openFoodPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FoodPicker(
        onPick: (food, grams, meal) {
          ref.read(foodLogProvider.notifier).addFromFood(food, grams, meal);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _ScanCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider =
        ref.watch(aiConfigProvider).providerFor(AiTask.foodVision);
    final ready = provider != null && provider.isConfigured;
    return FitCard(
      onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ready
            ? 'Camera capture → ${provider.model} analysis wires up in the AI phase'
            : 'Add a vision AI provider in Admin → AI Settings to enable photo scanning'),
      )),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: AppColors.pink.withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: const Icon(Icons.camera_alt_rounded, color: AppColors.pink),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Scan a meal',
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                    ready
                        ? 'Vision AI ready · ${provider.vendor.label}'
                        : 'Snap a photo for instant calories (needs AI provider)',
                    style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
          Icon(ready ? Icons.check_circle : Icons.chevron_right_rounded,
              color: ready ? AppColors.success : null),
        ],
      ),
    );
  }
}

class _FoodPicker extends StatefulWidget {
  const _FoodPicker({required this.onPick});
  final void Function(FoodItem, int grams, MealType) onPick;

  @override
  State<_FoodPicker> createState() => _FoodPickerState();
}

class _FoodPickerState extends State<_FoodPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final results = FoodSeed.all
        .where((f) => f.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      builder: (context, scroll) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search foods…',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: context.fit.surfaceAlt,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(Radii.pill),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: scroll,
              itemCount: results.length,
              itemBuilder: (_, i) {
                final f = results[i];
                return ListTile(
                  leading: Text(f.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(f.name),
                  subtitle: Text(
                      '${f.kcalPer100g} kcal/100g · ${f.category}'),
                  trailing: Text('${f.kcalPerServing} kcal',
                      style: const TextStyle(
                          color: AppColors.pink, fontWeight: FontWeight.w700)),
                  onTap: () => _quantitySheet(context, f),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _quantitySheet(BuildContext context, FoodItem food) {
    var grams = food.commonServingG.toDouble();
    var meal = MealType.lunch;
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocal) => Padding(
          padding: const EdgeInsets.all(Insets.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${food.emoji}  ${food.name}',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Insets.sm),
              Text('${food.kcalForGrams(grams.round())} kcal · ${grams.round()} g',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.pink)),
              Slider(
                value: grams.clamp(10, 500),
                min: 10,
                max: 500,
                activeColor: AppColors.pink,
                onChanged: (v) => setLocal(() => grams = v),
              ),
              Wrap(
                spacing: Insets.sm,
                children: [
                  for (final m in MealType.values)
                    ChoiceChip(
                      label: Text(m.label),
                      selected: meal == m,
                      selectedColor: AppColors.pinkTint,
                      onSelected: (_) => setLocal(() => meal = m),
                    ),
                ],
              ),
              const SizedBox(height: Insets.lg),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style:
                      FilledButton.styleFrom(backgroundColor: AppColors.pink),
                  onPressed: () {
                    Navigator.pop(context); // close quantity
                    widget.onPick(food, grams.round(), meal);
                  },
                  child: const Text('Add to log'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
