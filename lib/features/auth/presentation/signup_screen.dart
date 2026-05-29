import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/blob_background.dart';
import '../../../core/widgets/fit_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../application/auth_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Enter a name, email, and a 6+ char password')));
      return;
    }
    final ok = await ref
        .read(authProvider.notifier)
        .signUp(_name.text, _email.text, _password.text);
    if (ok && mounted) context.go('/'); // new users go through onboarding gate
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(),
      body: BlobBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: Insets.screenH),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: Insets.lg),
                Text('Create your account',
                    style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: Insets.xs),
                Text('Start training smarter today',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: Insets.xxl),
                FitTextField(
                    label: 'Name',
                    controller: _name,
                    icon: Icons.person_outline_rounded),
                const SizedBox(height: Insets.md),
                FitTextField(
                    label: 'Email',
                    controller: _email,
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress),
                const SizedBox(height: Insets.md),
                FitTextField(
                    label: 'Password',
                    controller: _password,
                    icon: Icons.lock_outline_rounded,
                    obscure: true),
                if (auth.error != null) ...[
                  const SizedBox(height: Insets.md),
                  Text(auth.error!, style: const TextStyle(color: AppColors.danger)),
                ],
                const SizedBox(height: Insets.xl),
                PrimaryButton(
                    label: 'Sign up',
                    loading: auth.loading,
                    onPressed: _submit),
                const SizedBox(height: Insets.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
