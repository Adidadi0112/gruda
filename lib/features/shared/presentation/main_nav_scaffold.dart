import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../home/presentation/screens/home_screen.dart';
import '../../meal/presentation/screens/meal_planner_screen.dart';
import '../../settings/presentation/screens/settings_screen.dart';

/// MainNavScaffold - The main app scaffold with BottomNavigationBar.
/// Routes between Dashboard, Meal Planner, and Settings.
class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key});

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const MealPlannerScreen(),
    const SettingsScreen(),
  ];

  /// Maps screen index to bottom nav index
  /// Screen: 0=Home, 1=Meals, 2=Settings
  /// NavBar: 0=Home, 1=Meals, 2=Settings
  int _getNavIndex(int screenIndex) {
    return screenIndex;
  }

  /// Maps bottom nav index to screen index
  int _getScreenIndex(int navIndex) {
    return navIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getNavIndex(_selectedIndex),
        onTap: (index) {
          setState(() => _selectedIndex = _getScreenIndex(index));
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard),
            label: 'Kokpit',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.utensils),
            label: 'Posiłki',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.settings),
            label: 'Ustawienia',
          ),
        ],
      ),
    );
  }
}
