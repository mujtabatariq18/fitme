import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/fit_card.dart';
import '../../auth/application/auth_controller.dart';
import '../../onboarding/application/profile_controller.dart';
import '../../onboarding/domain/user_profile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    final auth = ref.watch(authProvider);
    final user = auth.user;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(Insets.screenH),
        children: [
          if (user != null) ...[
            FitCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: user.isAdmin
                        ? AppColors.deepMagenta
                        : AppColors.pinkTint,
                    child: Icon(
                        user.isAdmin
                            ? Icons.shield_rounded
                            : Icons.person_rounded,
                        color: user.isAdmin
                            ? Colors.white
                            : AppColors.deepMagenta),
                  ),
                  const SizedBox(width: Insets.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('${user.email} · ${user.isAdmin ? "Admin" : "Member"}',
                            style: Theme.of(context).textTheme.labelMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Insets.lg),
          ],
          FitCard(
            child: Column(
              children: [
                _row(context, Icons.flag_rounded, 'Goal', p.goal.label),
                const Divider(),
                _row(context, Icons.restaurant_rounded, 'Diet', p.dietType.label),
                const Divider(),
                _row(context, Icons.local_fire_department_rounded,
                    'Daily target', '${p.dailyCalorieTarget ?? "—"} kcal'),
              ],
            ),
          ),
          const SizedBox(height: Insets.lg),
          _tile(context, Icons.health_and_safety_rounded,
              'Connect health data', 'Apple Health · Google Fit',
              () => _soon(context)),
          _tile(context, Icons.notifications_rounded, 'Notifications',
              'Reminders & coaching nudges', () => _soon(context)),
          if (auth.isAdmin) ...[
            const SizedBox(height: Insets.lg),
            Text('  ADMIN', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: Insets.sm),
            _tile(context, Icons.smart_toy_rounded, 'AI Settings',
                'Providers, API keys & task routing',
                () => context.push('/settings/ai'),
                accent: AppColors.deepMagenta),
            _tile(context, Icons.group_rounded, 'User Management',
                'Roles, access & accounts',
                () => context.push('/admin/users'),
                accent: AppColors.deepMagenta),
          ],
          const SizedBox(height: Insets.lg),
          _tile(context, Icons.logout_rounded, 'Log out',
              user?.email ?? '', () {
            ref.read(authProvider.notifier).logout();
            context.go('/');
          }, accent: AppColors.danger),
          const SizedBox(height: Insets.sm),
          TextButton(
            onPressed: () {
              ref.read(profileProvider.notifier).reset();
              context.go('/');
            },
            child: const Text('Reset onboarding',
                style: TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext c, IconData i, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: Insets.sm),
        child: Row(
          children: [
            Icon(i, color: AppColors.pink, size: 20),
            const SizedBox(width: Insets.md),
            Text(label, style: Theme.of(c).textTheme.titleMedium),
            const Spacer(),
            Text(value, style: Theme.of(c).textTheme.bodyMedium),
          ],
        ),
      );

  Widget _tile(BuildContext c, IconData i, String title, String sub,
      VoidCallback onTap, {Color accent = AppColors.pink}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.md),
      child: FitCard(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(i, color: accent),
            ),
            const SizedBox(width: Insets.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(c).textTheme.titleMedium),
                  Text(sub, style: Theme.of(c).textTheme.bodyMedium),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }

  void _soon(BuildContext c) => ScaffoldMessenger.of(c).showSnackBar(
        const SnackBar(content: Text('Coming in the next phase')),
      );
}
