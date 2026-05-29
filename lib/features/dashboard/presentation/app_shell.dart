import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../coach/presentation/coach_screen.dart';
import '../../nutrition/presentation/meal_plan_screen.dart';
import '../../progress/presentation/progress_screen.dart';
import '../../workouts/presentation/workouts_screen.dart';
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
    MealPlanScreen(),
    CoachScreen(),
    ProgressScreen(),
    WorkoutsScreen(),
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
              selectedIcon:
                  Icon(Icons.home_rounded, color: AppColors.deepMagenta),
              label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu_rounded,
                  color: AppColors.deepMagenta),
              label: 'Meals'),
          NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome_rounded,
                  color: AppColors.deepMagenta),
              label: 'Coach'),
          NavigationDestination(
              icon: Icon(Icons.show_chart_outlined),
              selectedIcon: Icon(Icons.show_chart_rounded,
                  color: AppColors.deepMagenta),
              label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center_outlined),
              selectedIcon: Icon(Icons.fitness_center_rounded,
                  color: AppColors.deepMagenta),
              label: 'Workouts'),
        ],
      ),
    );
  }
}
