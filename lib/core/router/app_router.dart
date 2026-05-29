import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/ai_settings_screen.dart';
import '../../features/admin/presentation/user_management_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/dashboard/presentation/app_shell.dart';
import '../../features/notifications/presentation/reminders_screen.dart';
import '../../features/nutrition/presentation/food_log_screen.dart';
import '../../features/onboarding/application/profile_controller.dart';
import '../../features/onboarding/presentation/onboarding_flow.dart';
import '../../features/onboarding/presentation/plan_ready_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/workouts/presentation/workouts_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final done = ref.read(profileProvider).onboardingComplete;
      final loc = state.matchedLocation;

      final atAuth = loc == '/login' || loc == '/signup';
      final inOnboarding = loc == '/welcome' || loc.startsWith('/onboarding');
      final adminRoute = loc == '/settings/ai' || loc == '/admin/users';

      // 1. Not authenticated → only the auth screens are reachable.
      if (!auth.isAuthenticated) return atAuth ? null : '/login';

      // 2. Authenticated but onboarding incomplete → funnel through onboarding.
      if (!done) return inOnboarding ? null : '/welcome';

      // 3. Fully set up → keep them out of auth/onboarding/root.
      if (atAuth || inOnboarding || loc == '/') return '/home';

      // 4. Admin-only routes require the admin role.
      if (adminRoute && !auth.isAdmin) return '/home';

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Blank()),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, _) => const SignupScreen()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingFlow()),
      GoRoute(
          path: '/onboarding/summary',
          builder: (_, _) => const PlanReadyScreen()),
      GoRoute(path: '/home', builder: (_, _) => const AppShell()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
          path: '/settings/ai', builder: (_, _) => const AiSettingsScreen()),
      GoRoute(
          path: '/admin/users',
          builder: (_, _) => const UserManagementScreen()),
      GoRoute(path: '/food', builder: (_, _) => const FoodLogScreen()),
      GoRoute(
          path: '/settings/reminders',
          builder: (_, _) => const RemindersScreen()),
      GoRoute(path: '/workouts', builder: (_, _) => const WorkoutsScreen()),
      GoRoute(path: '/progress', builder: (_, _) => const ProgressScreen()),
    ],
  );
});

class _Blank extends StatelessWidget {
  const _Blank();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
