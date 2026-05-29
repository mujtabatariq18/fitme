import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/admin/presentation/ai_settings_screen.dart';
import '../../features/dashboard/presentation/app_shell.dart';
import '../../features/onboarding/application/profile_controller.dart';
import '../../features/onboarding/presentation/onboarding_flow.dart';
import '../../features/onboarding/presentation/plan_ready_screen.dart';
import '../../features/onboarding/presentation/welcome_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final done = ref.read(profileProvider).onboardingComplete;
      final loc = state.matchedLocation;
      // Gate the app: unfinished onboarding can't reach /home.
      if (loc == '/') return done ? '/home' : '/welcome';
      final inOnboarding = loc.startsWith('/welcome') || loc.startsWith('/onboarding');
      if (!done && loc == '/home') return '/welcome';
      if (done && inOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Blank()),
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomeScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingFlow()),
      GoRoute(
          path: '/onboarding/summary',
          builder: (_, _) => const PlanReadyScreen()),
      GoRoute(path: '/home', builder: (_, _) => const AppShell()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(
          path: '/settings/ai', builder: (_, _) => const AiSettingsScreen()),
    ],
  );
});

class _Blank extends StatelessWidget {
  const _Blank();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
