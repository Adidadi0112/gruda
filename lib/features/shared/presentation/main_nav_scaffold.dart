import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../home/presentation/screens/home_screen.dart';
import '../../meal/presentation/screens/meal_planner_screen.dart';
import '../../meal/presentation/screens/shopping_list_screen.dart';
import '../../settings/presentation/screens/settings_screen.dart';

/// MainNavScaffold - The main app scaffold with BottomNavigationBar.
/// Routes between Dashboard, Meal Planner, Shopping List, and Settings.
class MainNavScaffold extends StatefulWidget {
  const MainNavScaffold({super.key});

  @override
  State<MainNavScaffold> createState() => _MainNavScaffoldState();
}

class _MainNavScaffoldState extends State<MainNavScaffold> {
  int _selectedIndex = 0;

  void _onNavigate(int index) {
    setState(() => _selectedIndex = index);
  }

  late final List<Widget> _screens = [
    HomeScreen(onNavigate: _onNavigate),
    const MealPlannerScreen(),
    const ShoppingListScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 2 ? 0 : _selectedIndex,
        onTap: (index) {
          // Map bottom nav index to screen index
          int screenIndex = index;
          if (index == 2) {
            // Settings is at index 3 in screens, but index 2 in nav bar
            screenIndex = 3;
          }
          setState(() => _selectedIndex = screenIndex);
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
