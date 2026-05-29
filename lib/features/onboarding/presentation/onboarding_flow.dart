import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/profile_controller.dart';
import '../domain/user_profile.dart';
import 'widgets/onboarding_steps.dart';

/// Definition of one onboarding step.
class _Step {
  const _Step({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.isValid,
  });
  final String title;
  final String subtitle;
  final Widget body;
  final bool Function(UserProfile) isValid;
}

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _pageController = PageController();
  int _index = 0;

  late final List<_Step> _steps = [
    _Step(
      title: 'What\'s your gender?',
      subtitle: 'So we can personalize your avatar and targets.',
      body: const GenderStep(),
      isValid: (_) => true,
    ),
    _Step(
      title: 'What\'s your main goal?',
      subtitle: 'We\'ll shape your plan around this.',
      body: const GoalStep(),
      isValid: (_) => true,
    ),
    _Step(
      title: 'Select your problem areas',
      subtitle: 'Pick the areas you want to focus on.',
      body: const AreasStep(),
      isValid: (p) => p.problemAreas.isNotEmpty,
    ),
    _Step(
      title: 'Tell us about you',
      subtitle: 'This powers your calorie & activity targets.',
      body: const BodyStatsStep(),
      isValid: (_) => true,
    ),
    _Step(
      title: 'What\'s your target weight?',
      subtitle: 'Set a goal — you can change it anytime.',
      body: const TargetWeightStep(),
      isValid: (_) => true,
    ),
    _Step(
      title: 'How active are you?',
      subtitle: 'Be honest — we\'ll adjust as you go.',
      body: const ActivityStep(),
      isValid: (_) => true,
    ),
    _Step(
      title: 'Any diet preference?',
      subtitle: 'We\'ll plan meals that fit your style.',
      body: const DietStep(),
      isValid: (_) => true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Seed sensible defaults so derived nutrition math is always valid.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = ref.read(profileProvider.notifier);
      final p = ref.read(profileProvider);
      if (p.birthYear == null) ctrl.setBirthYear(2026 - 28);
      if (p.heightCm == null) ctrl.setHeight(165);
      if (p.currentWeightKg == null) ctrl.setCurrentWeight(65);
      if (p.targetWeightKg == null) ctrl.setTargetWeight(60);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _steps.length - 1) {
      context.go('/onboarding/summary');
      return;
    }
    setState(() => _index++);
    _pageController.animateToPage(_index,
        duration: Motion.base, curve: Motion.emphasized);
  }

  void _back() {
    if (_index == 0) {
      context.pop();
      return;
    }
    setState(() => _index--);
    _pageController.animateToPage(_index,
        duration: Motion.base, curve: Motion.emphasized);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final step = _steps[_index];
    final valid = step.isValid(profile);
    final progress = (_index + 1) / _steps.length;
    final isLast = _index == _steps.length - 1;

    return Scaffold(
      body: BlobBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header: back + animated progress bar.
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Insets.md, Insets.sm, Insets.xl, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.pill),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: Motion.base,
                          curve: Motion.emphasized,
                          builder: (_, v, _) => LinearProgressIndicator(
                            value: v,
                            minHeight: 8,
                            backgroundColor: AppColors.pinkTint,
                            valueColor:
                                const AlwaysStoppedAnimation(AppColors.pink),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: Insets.md),
                    Text('${_index + 1}/${_steps.length}',
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _steps.length,
                  itemBuilder: (context, i) {
                    final s = _steps[i];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(Insets.screenH,
                          Insets.xl, Insets.screenH, Insets.xl),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title,
                              style:
                                  Theme.of(context).textTheme.displayMedium),
                          const SizedBox(height: Insets.sm),
                          Text(s.subtitle,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: context.fit.textSecondary)),
                          const SizedBox(height: Insets.xxxl),
                          s.body,
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(Insets.screenH, Insets.sm,
                    Insets.screenH, Insets.lg),
                child: PrimaryButton(
                  label: isLast ? 'Build my plan' : 'Continue',
                  icon: isLast ? Icons.auto_awesome_rounded : null,
                  enabled: valid,
                  onPressed: _next,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
