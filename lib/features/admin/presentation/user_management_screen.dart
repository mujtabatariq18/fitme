import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/fit_card.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/domain/app_user.dart';

class UserManagementScreen extends ConsumerWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(authProvider).accounts;
    final ctrl = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: ListView(
        padding: const EdgeInsets.all(Insets.screenH),
        children: [
          Text('${accounts.length} accounts',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: Insets.md),
          for (final u in accounts)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.md),
              child: FitCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: u.isAdmin
                              ? AppColors.deepMagenta
                              : AppColors.pinkTint,
                          child: Icon(
                              u.isAdmin
                                  ? Icons.shield_rounded
                                  : Icons.person_rounded,
                              color:
                                  u.isAdmin ? Colors.white : AppColors.deepMagenta),
                        ),
                        const SizedBox(width: Insets.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(u.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium),
                              Text(u.email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium),
                            ],
                          ),
                        ),
                        if (!u.enabled)
                          const Chip(
                              label: Text('disabled'),
                              backgroundColor: Color(0xFFFFE0E0)),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          const Text('Admin'),
                          Switch(
                            value: u.isAdmin,
                            activeThumbColor: AppColors.deepMagenta,
                            onChanged: (v) => ctrl.setRole(
                                u.id, v ? UserRole.admin : UserRole.user),
                          ),
                        ]),
                        Row(children: [
                          const Text('Enabled'),
                          Switch(
                            value: u.enabled,
                            activeThumbColor: AppColors.success,
                            onChanged: (v) => ctrl.setEnabled(u.id, v),
                          ),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
