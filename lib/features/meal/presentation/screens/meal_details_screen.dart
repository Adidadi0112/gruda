import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/meal_plan.dart';
import '../meal_provider.dart';
import '../widgets/meal_details_editor.dart';

/// MealDetailsScreen - Displays full meal details (title, ingredients, instructions).
/// Accessed when tapping a meal in the Meal Planner.
class MealDetailsScreen extends ConsumerStatefulWidget {
  final MealPlan meal;

  const MealDetailsScreen({super.key, required this.meal});

  @override
  ConsumerState<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends ConsumerState<MealDetailsScreen> {
  late MealPlan editingMeal;

  @override
  void initState() {
    super.initState();
    editingMeal = widget.meal;
  }

  void _openEditModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => MealEditModal(
        meal: editingMeal,
        onSave: (updatedMeal) {
          setState(() => editingMeal = updatedMeal);
          ref.read(updateMealProvider(updatedMeal).future).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Posiłek zaktualizowany')),
            );
          });
        },
      ),
    );
  }

  Future<void> _deleteMeal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Usuń posiłek?'),
        content: Text('Czy chcesz usunąć "${editingMeal.recipeName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await ref.read(deleteMealProvider(editingMeal.id).future);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Posiłek usunięty')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Błąd: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    final label = mealTypeLabels[editingMeal.mealType] ?? editingMeal.mealType;
    final icon = mealIcons[editingMeal.mealType] ?? LucideIcons.utensils;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Szczegóły posiłku'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.edit),
            onPressed: _openEditModal,
            tooltip: 'Edytuj',
          ),
          IconButton(
            icon: const Icon(LucideIcons.trash2),
            onPressed: _deleteMeal,
            tooltip: 'Usuń',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Title and Type
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 32, color: theme.colorScheme.primary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                editingMeal.recipeName,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                label,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Date & Prep Info
                    Row(
                      children: [
                        Icon(
                          LucideIcons.calendar,
                          size: 16,
                          color: theme.colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatDate(editingMeal.mealDate),
                          style: theme.textTheme.labelSmall,
                        ),
                        const SizedBox(width: 16),
                        if (editingMeal.prepGroupId != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  LucideIcons.check,
                                  size: 14,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Meal Prep',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Ingredients Section
            if (editingMeal.ingredientsList.isNotEmpty) ...[
              Text(
                'Składniki',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: editingMeal.ingredientsList.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '• ',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ingredient.toString(),
                                style: theme.textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Instructions Section
            if (editingMeal.instructionsList.isNotEmpty) ...[
              Text(
                'Instrukcje przygotowania',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: editingMeal.instructionsList.map((instruction) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                border: Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Center(
                                child: Text(
                                  '${instruction.step}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                instruction.text,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // No Details Info (updated to check new fields)
            if (editingMeal.ingredientsList.isEmpty &&
                editingMeal.instructionsList.isEmpty)
              Center(
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.info,
                      size: 48,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Brak szczegółów',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      icon: const Icon(LucideIcons.plus),
                      label: const Text('Dodaj szczegóły'),
                      onPressed: _openEditModal,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const monthNames = [
      'sty',
      'lut',
      'mar',
      'kwi',
      'maj',
      'cze',
      'lip',
      'sie',
      'wrz',
      'paź',
      'lis',
      'gru',
    ];
    const dayNames = ['Pon', 'Wto', 'Śro', 'Czw', 'Pią', 'Sob', 'Nie'];
    return '${dayNames[date.weekday - 1]} ${date.day} ${monthNames[date.month - 1]}';
  }
}

/// MealEditModal - For editing existing meal details using MealDetailsEditor
class MealEditModal extends StatefulWidget {
  final MealPlan meal;
  final Function(MealPlan) onSave;

  const MealEditModal({super.key, required this.meal, required this.onSave});

  @override
  State<MealEditModal> createState() => _MealEditModalState();
}

class _MealEditModalState extends State<MealEditModal> {
  @override
  Widget build(BuildContext context) {
    return MealDetailsEditor(
      mealType: widget.meal.mealType,
      initialTitle: widget.meal.recipeName,
      initialIngredients: widget.meal.ingredientsList,
      initialInstructions: widget.meal.instructionsList,
      onSave: (title, ingredients, instructions) {
        final updatedMeal = widget.meal.copyWith(
          recipeName: title,
          ingredientsList: ingredients,
          instructionsList: instructions,
        );
        widget.onSave(updatedMeal);
      },
    );
  }
}
