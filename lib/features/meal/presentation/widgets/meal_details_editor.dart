import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/meal_plan.dart';

/// MealDetailsEditor - A comprehensive sub-form for defining meal details.
/// Supports:
/// - Title/recipe name
/// - Dynamic ingredients list (with amounts and units)
/// - Numbered instruction steps
///
/// Used inside the MealPrepWizardBottomSheet when editing meal details.
class MealDetailsEditor extends StatefulWidget {
  final String mealType;
  final String? initialTitle;
  final List<Ingredient> initialIngredients;
  final List<InstructionStep> initialInstructions;
  final Function(
    String title,
    List<Ingredient> ingredients,
    List<InstructionStep> instructions,
  )
  onSave;

  const MealDetailsEditor({
    super.key,
    required this.mealType,
    this.initialTitle,
    this.initialIngredients = const [],
    this.initialInstructions = const [],
    required this.onSave,
  });

  @override
  State<MealDetailsEditor> createState() => _MealDetailsEditorState();
}

class _MealDetailsEditorState extends State<MealDetailsEditor> {
  late TextEditingController titleController;
  late List<_IngredientRow> ingredientRows;
  late List<_InstructionRow> instructionRows;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle ?? '');

    // Initialize ingredient rows
    ingredientRows = widget.initialIngredients
        .map(
          (ing) => _IngredientRow(
            amount: ing.amount ?? '',
            unit: ing.unit ?? '',
            name: ing.name,
          ),
        )
        .toList();
    if (ingredientRows.isEmpty) {
      ingredientRows.add(_IngredientRow(amount: '', unit: '', name: ''));
    }

    // Initialize instruction rows
    instructionRows = widget.initialInstructions
        .map((instr) => _InstructionRow(step: instr.step, text: instr.text))
        .toList();
    if (instructionRows.isEmpty) {
      instructionRows.add(_InstructionRow(step: 1, text: ''));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    for (var row in ingredientRows) {
      row.amountController.dispose();
      row.unitController.dispose();
      row.nameController.dispose();
    }
    for (var row in instructionRows) {
      row.textController.dispose();
    }
    super.dispose();
  }

  void _addIngredientRow() {
    setState(() {
      ingredientRows.add(_IngredientRow(amount: '', unit: '', name: ''));
    });
  }

  void _removeIngredientRow(int index) {
    setState(() {
      ingredientRows.removeAt(index);
    });
  }

  void _addInstructionRow() {
    setState(() {
      final nextStep = (instructionRows.lastOrNull?.step ?? 0) + 1;
      instructionRows.add(_InstructionRow(step: nextStep, text: ''));
    });
  }

  void _removeInstructionRow(int index) {
    setState(() {
      final removedStep = instructionRows[index].step;
      instructionRows.removeAt(index);
      // Renumber subsequent steps
      for (int i = index; i < instructionRows.length; i++) {
        instructionRows[i].step = removedStep + i;
      }
    });
  }

  void _save() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Podaj nazwę posiłku')));
      return;
    }

    // Build ingredients list
    final ingredients = <Ingredient>[];
    for (var row in ingredientRows) {
      if (row.nameController.text.trim().isNotEmpty) {
        ingredients.add(
          Ingredient(
            name: row.nameController.text.trim(),
            amount: row.amountController.text.trim().isEmpty
                ? null
                : row.amountController.text.trim(),
            unit: row.unitController.text.trim().isEmpty
                ? null
                : row.unitController.text.trim(),
          ),
        );
      }
    }

    // Build instructions list
    final instructions = <InstructionStep>[];
    for (var row in instructionRows) {
      if (row.textController.text.trim().isNotEmpty) {
        instructions.add(
          InstructionStep(step: row.step, text: row.textController.text.trim()),
        );
      }
    }

    widget.onSave(titleController.text, ingredients, instructions);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Szczegóły posiłku'),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(LucideIcons.x),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Field
                Text('Nazwa posiłku', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'np. Spaghetti Carbonara',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Ingredients Section
                Text('Składniki', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                // Ingredient header row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: const [
                      SizedBox(
                        width: 60,
                        child: Text(
                          'Ilość',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          'Jednostka',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nazwa',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Ingredient rows
                ...ingredientRows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        // Amount field
                        SizedBox(
                          width: 60,
                          child: TextField(
                            controller: row.amountController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'np. 500',
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Unit field
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: row.unitController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'np. g',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Ingredient name
                        Expanded(
                          child: TextField(
                            controller: row.nameController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'np. kurczak',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        if (ingredientRows.length > 1)
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              icon: const Icon(LucideIcons.trash, size: 18),
                              onPressed: () => _removeIngredientRow(index),
                              padding: EdgeInsets.zero,
                            ),
                          )
                        else
                          const SizedBox(width: 40),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // Add ingredient button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: const Icon(LucideIcons.plus),
                    label: const Text('Dodaj składnik'),
                    onPressed: _addIngredientRow,
                  ),
                ),
                const SizedBox(height: 24),

                // Instructions Section
                Text(
                  'Instrukcje przygotowania',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                // Instruction rows
                ...instructionRows.asMap().entries.map((entry) {
                  final index = entry.key;
                  final row = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Step number
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            border: Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${row.step}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Instruction text
                        Expanded(
                          child: TextField(
                            controller: row.textController,
                            maxLines: null,
                            minLines: 2,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              hintText: 'Opisz krok ${row.step}...',
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Delete button
                        if (instructionRows.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: IconButton(
                              icon: const Icon(LucideIcons.trash, size: 18),
                              onPressed: () => _removeInstructionRow(index),
                              padding: EdgeInsets.zero,
                            ),
                          )
                        else
                          const SizedBox(width: 40),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 8),
                // Add instruction button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: const Icon(LucideIcons.plus),
                    label: const Text('Dodaj krok'),
                    onPressed: _addInstructionRow,
                  ),
                ),
                const SizedBox(height: 24),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _save,
                    child: const Text('Zapisz szczegóły'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Helper class for ingredient UI state
class _IngredientRow {
  final TextEditingController amountController;
  final TextEditingController unitController;
  final TextEditingController nameController;

  _IngredientRow({
    required String amount,
    required String unit,
    required String name,
  }) : amountController = TextEditingController(text: amount),
       unitController = TextEditingController(text: unit),
       nameController = TextEditingController(text: name);
}

/// Helper class for instruction UI state
class _InstructionRow {
  int step;
  final TextEditingController textController;

  _InstructionRow({required this.step, required String text})
    : textController = TextEditingController(text: text);
}
