import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/fitme_logo.dart';
import '../../../core/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _props = [
    ('🎯', 'Personalized to your body', 'Target your problem areas with a plan made for you'),
    ('🍽️', 'Snap your meals', 'AI calorie & macro tracking from a single photo'),
    ('📈', 'Track real progress', 'Sync Apple Health & wearables, see what works'),
  ];

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Scaffold(
      body: BlobBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
            child: Column(
              children: [
                const Spacer(flex: 2),
                const FitMeBrandImage(size: 104),
                const SizedBox(height: Insets.xxl),
                Text(
                  'Your body,\nyour plan.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: Insets.md),
                Text(
                  'AI coaching that adapts to your goals, your meals and your real health data.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: fit.textSecondary,
                      ),
                ),
                const Spacer(),
                ..._props.map((p) => _PropRow(emoji: p.$1, title: p.$2, sub: p.$3)),
                const Spacer(flex: 2),
                PrimaryButton(
                  label: 'Set up my plan',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () => context.push('/onboarding'),
                ),
                const SizedBox(height: Insets.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PropRow extends StatelessWidget {
  const _PropRow({required this.emoji, required this.title, required this.sub});
  final String emoji, title, sub;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.pinkTint,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: Insets.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(sub, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
