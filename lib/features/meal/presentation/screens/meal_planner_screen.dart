import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../meal_provider.dart';
import '../widgets/meal_prep_wizard_bottom_sheet.dart';
import 'meal_details_screen.dart';

/// MealPlannerScreen - Displays meals in a calendar view.
/// - Horizontal calendar at the top
/// - Daily meals list for selected date
class MealPlannerScreen extends ConsumerStatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  ConsumerState<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends ConsumerState<MealPlannerScreen> {
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  void _openMealPrepWizard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const MealPrepWizardBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mealsAsync = ref.watch(allMealsProviderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan Posiłków'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plus),
            onPressed: _openMealPrepWizard,
            tooltip: 'Zaplanuj 3 dni',
          ),
        ],
      ),
      body: Column(
        children: [
          // Horizontal Calendar
          _buildHorizontalCalendar(theme),
          // Divider
          Divider(height: 1, color: theme.colorScheme.surfaceContainerHighest),
          // Meals List
          Expanded(
            child: mealsAsync.when(
              data: (meals) {
                // Filter meals for selected date
                final filteredMeals = meals.where((meal) {
                  final sameDay =
                      meal.mealDate.year == selectedDate.year &&
                      meal.mealDate.month == selectedDate.month &&
                      meal.mealDate.day == selectedDate.day;
                  return sameDay;
                }).toList();

                if (filteredMeals.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.utensils,
                          size: 48,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Brak posiłków na ten dzień',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.secondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        FilledButton.icon(
                          icon: const Icon(LucideIcons.plus),
                          label: const Text('Zaplanuj 3 dni'),
                          onPressed: _openMealPrepWizard,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMeals.length,
                  itemBuilder: (context, index) {
                    final meal = filteredMeals[index];
                    return _buildMealCard(meal, theme);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Błąd: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar(ThemeData theme) {
    // Generate 14 days from today
    final days = List.generate(
      14,
      (index) => DateTime.now().add(Duration(days: index)),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        children: days.map((date) {
          final isSelected =
              date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          final isToday =
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => setState(() => selectedDate = date),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: isToday
                      ? Border.all(color: theme.colorScheme.primary, width: 2)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _dayName(date),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${date.day}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMealCard(dynamic meal, ThemeData theme) {
    // The meal object from the provider
    final recipeName = meal.recipeName;
    final mealType = meal.mealType;
    final prepGroupId = meal.prepGroupId;

    const mealTypeLabels = {
      'breakfast': 'Śniadanie',
      'lunch': 'Obiad',
      'dinner': 'Kolacja',
      'snack': 'Przekąska',
      'dessert': 'Deser',
    };

    const mealIcons = {
      'breakfast': LucideIcons.coffee,
      'lunch': LucideIcons.utensils,
      'dinner': LucideIcons.moon,
      'snack': LucideIcons.apple,
      'dessert': LucideIcons.cakeSlice,
    };

    final label = mealTypeLabels[mealType] ?? mealType;
    final icon = mealIcons[mealType] ?? LucideIcons.utensils;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(recipeName),
        subtitle: Text(label),
        trailing: prepGroupId != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Prep',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : null,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MealDetailsScreen(meal: meal),
            ),
          );
        },
      ),
    );
  }

  String _dayName(DateTime date) {
    const names = ['Pn', 'Wt', 'Śr', 'Cz', 'Pt', 'So', 'Nd'];
    return names[date.weekday - 1];
  }
}
