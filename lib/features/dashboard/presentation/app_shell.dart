import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import 'home_screen.dart';

/// Bottom-nav container holding the primary app sections.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    _ComingSoon(icon: Icons.restaurant_menu_rounded, title: 'Meal Plan'),
    _ComingSoon(icon: Icons.auto_awesome_rounded, title: 'AI Coach'),
    _ComingSoon(icon: Icons.show_chart_rounded, title: 'Progress'),
    _ComingSoon(icon: Icons.fitness_center_rounded, title: 'Workouts'),
  ];

  @override
  Widget build(BuildContext context) {
    final fit = context.fit;
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: fit.surface,
        indicatorColor: AppColors.pinkTint,
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.deepMagenta),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu_rounded, color: AppColors.deepMagenta),
              label: 'Meals'),
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded, color: AppColors.deepMagenta),
              label: 'Coach'),
          NavigationDestination(
              icon: Icon(Icons.show_chart_outlined),
              selectedIcon: Icon(Icons.show_chart_rounded, color: AppColors.deepMagenta),
              label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center_rounded, color: AppColors.deepMagenta),
              label: 'Workouts'),
        ],
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppColors.pinkTint,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: AppColors.deepMagenta),
            ),
            const SizedBox(height: Insets.lg),
            Text('$title\nComing in the next phase',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
