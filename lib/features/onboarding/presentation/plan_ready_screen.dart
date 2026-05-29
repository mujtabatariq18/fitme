import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/fit_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/profile_controller.dart';
import '../domain/user_profile.dart';

class PlanReadyScreen extends ConsumerStatefulWidget {
  const PlanReadyScreen({super.key});

  @override
  ConsumerState<PlanReadyScreen> createState() => _PlanReadyScreenState();
}

class _PlanReadyScreenState extends ConsumerState<PlanReadyScreen> {
  bool _building = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) setState(() => _building = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(profileProvider);
    return Scaffold(
      body: BlobBackground(
        child: SafeArea(
          child: AnimatedSwitcher(
            duration: Motion.slow,
            child: _building ? const _Building() : _Result(profile: p),
          ),
        ),
      ),
    );
  }
}

class _Building extends StatelessWidget {
  const _Building();
  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('building'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: AppGradients.brand,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const SizedBox(
              width: 44,
              height: 44,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: Insets.xl),
          Text('Building your plan…',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: Insets.xs),
          Text('Crunching your goals & metabolism',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _Result extends ConsumerWidget {
  const _Result({required this.profile});
  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cals = profile.dailyCalorieTarget ?? 0;
    final macros = profile.macros;
    return Padding(
      key: const ValueKey('result'),
      padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
      child: Column(
        children: [
          const SizedBox(height: Insets.xl),
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
          ),
          const SizedBox(height: Insets.lg),
          Text('Your plan is ready',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: Insets.xs),
          Text('${profile.goal.label} · ${profile.dietType.label}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.fit.textSecondary,
                  )),
          const SizedBox(height: Insets.xxl),
          FitCard(
            padding: const EdgeInsets.all(Insets.xl),
            child: Column(
              children: [
                Text('Daily calorie target',
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: Insets.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$cals', style: _metricStyle(context)),
                    const SizedBox(width: 6),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('kcal',
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                  ],
                ),
                if (macros != null) ...[
                  const Divider(height: Insets.xxl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _Macro(label: 'Protein', grams: macros.protein, color: AppColors.pink),
                      _Macro(label: 'Carbs', grams: macros.carbs, color: AppColors.blue),
                      _Macro(label: 'Fat', grams: macros.fat, color: AppColors.calories),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: 'Start my journey',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              ref.read(profileProvider.notifier).completeOnboarding();
              context.go('/home');
            },
          ),
          const SizedBox(height: Insets.lg),
        ],
      ),
    );
  }
}

TextStyle _metricStyle(BuildContext context) =>
    Theme.of(context).textTheme.displayLarge!.copyWith(
          fontSize: 48,
          color: AppColors.deepMagenta,
        );

class _Macro extends StatelessWidget {
  const _Macro({required this.label, required this.grams, required this.color});
  final String label;
  final int grams;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${grams}g',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color)),
        const SizedBox(height: 2),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
