import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/meal_plan.dart';
import '../meal_provider.dart';
import 'meal_details_editor.dart';

/// MealTypes enum for the wizard's 5 meal slots per day.
const List<String> mealTypes = [
  'breakfast',
  'lunch',
  'dinner',
  'snack',
  'dessert',
];

/// Map meal types to display labels
const Map<String, String> mealTypeLabels = {
  'breakfast': 'Śniadanie',
  'lunch': 'Obiad',
  'dinner': 'Kolacja',
  'snack': 'Przekąska',
  'dessert': 'Deser',
};

/// MealData - Helper class to store meal details in the wizard
class _MealData {
  String title;
  List<Ingredient> ingredients;
  List<InstructionStep> instructions;

  _MealData({
    this.title = '',
    this.ingredients = const [],
    this.instructions = const [],
  });

  _MealData copyWith({
    String? title,
    List<Ingredient>? ingredients,
    List<InstructionStep>? instructions,
  }) {
    return _MealData(
      title: title ?? this.title,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
    );
  }
}

/// MealPrepWizardBottomSheet - A 3-day meal planning wizard.
/// Each day has 5 meal slots. Users can duplicate the previous day's meals
/// or define a completely new day.
class MealPrepWizardBottomSheet extends ConsumerStatefulWidget {
  const MealPrepWizardBottomSheet({super.key});

  @override
  ConsumerState<MealPrepWizardBottomSheet> createState() =>
      _MealPrepWizardBottomSheetState();
}

class _MealPrepWizardBottomSheetState
    extends ConsumerState<MealPrepWizardBottomSheet> {
  late DateTime startDate;
  // Day -> MealType -> MealData
  late Map<int, Map<String, _MealData>> mealsByDay;
  int currentDay = 0;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now().add(
      const Duration(days: 1),
    ); // Default to tomorrow
    _initializeMeals();
  }

  void _initializeMeals() {
    mealsByDay = {0: {}, 1: {}, 2: {}};
    for (final mealType in mealTypes) {
      for (int day = 0; day < 3; day++) {
        mealsByDay[day]![mealType] = _MealData();
      }
    }
  }

  void _duplicatePreviousDay(int day) {
    if (day == 0) return; // Can't duplicate before day 0
    final previousDay = mealsByDay[day - 1]!;
    mealsByDay[day] = previousDay.map(
      (mealType, mealData) => MapEntry(
        mealType,
        _MealData(
          title: mealData.title,
          ingredients: List.from(mealData.ingredients),
          instructions: List.from(mealData.instructions),
        ),
      ),
    );
    setState(() {});
  }

  void _clearDay(int day) {
    for (final mealType in mealTypes) {
      mealsByDay[day]![mealType] = _MealData();
    }
    setState(() {});
  }

  void _setMealDetails(
    int day,
    String mealType,
    String title,
    List<Ingredient> ingredients,
    List<InstructionStep> instructions,
  ) {
    mealsByDay[day]![mealType] = _MealData(
      title: title,
      ingredients: ingredients,
      instructions: instructions,
    );
    setState(() {});
  }

  Future<void> _submitMealPrep() async {
    if (isSubmitting) return;

    setState(() => isSubmitting = true);

    try {
      // Build the meals list for insertion
      final meals = <Map<String, dynamic>>[];

      for (int day = 0; day < 3; day++) {
        final mealDate = startDate.add(Duration(days: day));

        for (final mealType in mealTypes) {
          final mealData = mealsByDay[day]![mealType]!;

          if (mealData.title.isNotEmpty) {
            meals.add({
              'recipeName': mealData.title,
              'mealDate': mealDate,
              'mealType': mealType,
              'ingredientsList': mealData.ingredients
                  .map((ing) => ing.toJson())
                  .toList(),
              'instructionsList': mealData.instructions
                  .map((instr) => instr.toJson())
                  .toList(),
              'notes': null,
            });
          }
        }
      }

      if (meals.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Dodaj przynajmniej jeden posiłek')),
        );
        setState(() => isSubmitting = false);
        return;
      }

      // Call the bulk insert provider
      await ref.read(bulkInsertMealPrepProvider(meals: meals).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ ${meals.length} posiłków zaplanowano i dodano do koszyka',
            ),
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Błąd: $e')));
      }
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('3-dniowy Plan Zakupów'),
            centerTitle: true,
            elevation: 0,
          ),
          body: Column(
            children: [
              // Start Date Picker
              Padding(
                padding: const EdgeInsets.all(16),
                child: _buildStartDatePicker(theme),
              ),
              // Divider
              Divider(
                height: 1,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              // Day Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    3,
                    (day) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => currentDay = day),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: currentDay == day
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surfaceContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Dzień ${day + 1}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: currentDay == day
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _formatDate(startDate.add(Duration(days: day))),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: currentDay == day
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.secondary,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Divider
              Divider(
                height: 1,
                color: theme.colorScheme.surfaceContainerHighest,
              ),
              // Meal Slots for Current Day
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      // Duplication/Clear Buttons (visible for Day 2 and 3)
                      if (currentDay > 0)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(LucideIcons.copy),
                                  label: Text('Duplikuj Dzień ${currentDay}'),
                                  onPressed: () =>
                                      _duplicatePreviousDay(currentDay),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(LucideIcons.trash2),
                                  label: const Text('Wyczyść'),
                                  onPressed: () => _clearDay(currentDay),
                                ),
                              ),
                            ],
                          ),
                        ),
                      // Meal Input Fields
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(mealTypes.length, (index) {
                            final mealType = mealTypes[index];
                            final label = mealTypeLabels[mealType] ?? mealType;
                            final mealData = mealsByDay[currentDay]![mealType]!;
                            final title = mealData.title;
                            final hasDetails =
                                mealData.ingredients.isNotEmpty ||
                                mealData.instructions.isNotEmpty;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Card(
                                child: ListTile(
                                  leading: Icon(
                                    _getMealIcon(mealType),
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    title.isEmpty ? label : title,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: title.isEmpty
                                          ? theme.colorScheme.secondary
                                          : theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  subtitle: Text(
                                    title.isEmpty ? 'Dodaj szczegóły' : label,
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  trailing: hasDetails
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme.primary
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Icon(
                                            LucideIcons.check,
                                            size: 16,
                                            color: theme.colorScheme.primary,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      builder: (context) => MealDetailsEditor(
                                        mealType: mealType,
                                        initialTitle: title,
                                        initialIngredients:
                                            mealData.ingredients,
                                        initialInstructions:
                                            mealData.instructions,
                                        onSave:
                                            (title, ingredients, instructions) {
                                              _setMealDetails(
                                                currentDay,
                                                mealType,
                                                title,
                                                ingredients,
                                                instructions,
                                              );
                                            },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Submit Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: isSubmitting
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : const Icon(LucideIcons.check),
                    label: const Text('Zaplanuj posiłki'),
                    onPressed: isSubmitting ? null : _submitMealPrep,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Sty',
      'Lut',
      'Mar',
      'Kwi',
      'Maj',
      'Cze',
      'Lip',
      'Sie',
      'Wrz',
      'Paź',
      'Lis',
      'Gru',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  Widget _buildStartDatePicker(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Data rozpoczęcia:', style: theme.textTheme.titleSmall),
        TextButton.icon(
          icon: const Icon(LucideIcons.calendar),
          label: Text(
            _formatDate(startDate),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: startDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null && mounted) {
              setState(() => startDate = picked);
            }
          },
        ),
      ],
    );
  }

  IconData _getMealIcon(String mealType) {
    return switch (mealType) {
      'breakfast' => LucideIcons.coffee,
      'lunch' => LucideIcons.utensils,
      'dinner' => LucideIcons.moon,
      'snack' => LucideIcons.apple,
      'dessert' => LucideIcons.cakeSlice,
      _ => LucideIcons.utensils,
    };
  }
}
