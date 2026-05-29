import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/fit_text_field.dart';
import '../../../core/widgets/fitme_logo.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(authProvider.notifier)
        .login(_email.text, _password.text);
    if (ok && mounted) context.go('/');
  }

  void _fill(String email, String pw) {
    _email.text = email;
    _password.text = pw;
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final fit = context.fit;
    return Scaffold(
      body: BlobBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
            child: Column(
              children: [
                const SizedBox(height: Insets.huge),
                const FitMeBrandImage(size: 88),
                const SizedBox(height: Insets.lg),
                Text('Welcome back',
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: Insets.xs),
                Text('Log in to continue your journey',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: Insets.xxl),
                FitTextField(
                  label: 'Email',
                  controller: _email,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: Insets.md),
                FitTextField(
                  label: 'Password',
                  controller: _password,
                  icon: Icons.lock_outline_rounded,
                  obscure: _obscure,
                  suffix: IconButton(
                    icon: Icon(_obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                if (auth.error != null) ...[
                  const SizedBox(height: Insets.md),
                  Row(
                    children: [
                      const Icon(Icons.error_outline_rounded,
                          color: AppColors.danger, size: 18),
                      const SizedBox(width: Insets.sm),
                      Expanded(
                        child: Text(auth.error!,
                            style: const TextStyle(color: AppColors.danger)),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: Insets.xl),
                PrimaryButton(
                  label: 'Log in',
                  loading: auth.loading,
                  onPressed: _submit,
                ),
                const SizedBox(height: Insets.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("New here? ",
                        style: Theme.of(context).textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: const Text('Create account',
                          style: TextStyle(
                              color: AppColors.pink,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: Insets.xxl),
                // Demo credentials for quick access.
                Container(
                  padding: const EdgeInsets.all(Insets.md),
                  decoration: BoxDecoration(
                    color: fit.surfaceAlt,
                    borderRadius: BorderRadius.circular(Radii.md),
                    border: Border.all(color: fit.border),
                  ),
                  child: Column(
                    children: [
                      Text('Demo accounts — tap to fill',
                          style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: Insets.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _DemoChip(
                              label: '👤 User',
                              sub: 'demo@fitme.app',
                              onTap: () => _fill('demo@fitme.app', 'demo123'),
                            ),
                          ),
                          const SizedBox(width: Insets.sm),
                          Expanded(
                            child: _DemoChip(
                              label: '🛠 Admin',
                              sub: 'admin@fitme.app',
                              onTap: () => _fill('admin@fitme.app', 'admin123'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Insets.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip({required this.label, required this.sub, required this.onTap});
  final String label, sub;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Radii.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Insets.md, vertical: Insets.sm),
        decoration: BoxDecoration(
          color: fit.surface,
          borderRadius: BorderRadius.circular(Radii.sm),
          border: Border.all(color: fit.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 14)),
            Text(sub,
                style: Theme.of(context).textTheme.labelMedium,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}
