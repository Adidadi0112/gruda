import 'package:flutter/material.dart';

/// MealDetailsModal - A sub-modal for defining meal details (more than just title).
/// Opens from MealPrepWizardBottomSheet when user wants to add rich content to a meal.
class MealDetailsModal extends StatefulWidget {
  final String mealType;
  final String? initialTitle;
  final String? initialIngredients;
  final String? initialInstructions;
  final Function(String title, String? ingredients, String? instructions)
  onSave;

  const MealDetailsModal({
    super.key,
    required this.mealType,
    this.initialTitle,
    this.initialIngredients,
    this.initialInstructions,
    required this.onSave,
  });

  @override
  State<MealDetailsModal> createState() => _MealDetailsModalState();
}

class _MealDetailsModalState extends State<MealDetailsModal> {
  late TextEditingController titleController;
  late TextEditingController ingredientsController;
  late TextEditingController instructionsController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle ?? '');
    ingredientsController = TextEditingController(
      text: widget.initialIngredients ?? '',
    );
    instructionsController = TextEditingController(
      text: widget.initialInstructions ?? '',
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    ingredientsController.dispose();
    instructionsController.dispose();
    super.dispose();
  }

  void _save() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Podaj nazwę posiłku')));
      return;
    }

    widget.onSave(
      titleController.text,
      ingredientsController.text.isEmpty ? null : ingredientsController.text,
      instructionsController.text.isEmpty ? null : instructionsController.text,
    );
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
                icon: const Icon(Icons.close),
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
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),

                // Ingredients Field
                Text('Składniki', style: theme.textTheme.titleSmall),
                const SizedBox(height: 8),
                TextField(
                  controller: ingredientsController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: '• Jajka\n• Mleko\n• Mąka\n• Cukier',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),

                // Instructions Field
                Text(
                  'Instrukcje przygotowania',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: instructionsController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText:
                        '1. Wstępnie rozgrzej piekarnik\n2. Wymieszaj składniki\n3. ...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignLabelWithHint: true,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text('Zapisz szczegóły'),
                    onPressed: _save,
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
