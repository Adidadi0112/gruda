import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/icon_mapping.dart';
import '../../../habit/presentation/habit_provider.dart';
import '../../../task/presentation/task_provider.dart';

/// AddItemBottomSheet - Modal for creating new habits and tasks.
class AddHabitBottomSheet extends ConsumerStatefulWidget {
  const AddHabitBottomSheet({super.key});

  @override
  ConsumerState<AddHabitBottomSheet> createState() =>
      _AddItemBottomSheetState();
}

enum ItemType { habit, task }

class _AddItemBottomSheetState extends ConsumerState<AddHabitBottomSheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;

  bool _isLoading = false;
  bool _isHousehold = false;
  String? _errorMessage;
  List<String> _suggestedCategories = [];
  ItemType _itemType = ItemType.habit;
  DateTime _selectedDate = DateTime.now();
  String? _selectedIconName; // Selected icon key for habits

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _categoryController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load suggested categories from provider
    final categoriesAsync = ref.watch(uniqueCategoriesProvider);
    categoriesAsync.whenData((categories) {
      setState(() {
        _suggestedCategories = categories;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _handleAddItem() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() => _errorMessage = 'Title is required');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final category = _categoryController.text.trim().isEmpty
          ? null
          : _categoryController.text.trim();

      if (_itemType == ItemType.habit) {
        await ref.read(
          createHabitProvider(
            title: title,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            category: category,
            iconName: _selectedIconName,
            isHousehold: _isHousehold,
          ).future,
        );
      } else {
        await ref.read(
          addTaskProvider(
            title: title,
            category: category,
            dueDate: _selectedDate,
            isHousehold: _isHousehold,
          ).future,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Add Nawyk / Zadanie',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Item Type Selection (Switch)
            Row(
              children: [
                Expanded(
                  child: Text(
                    _itemType == ItemType.habit ? 'Nawyk' : 'Zadanie',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Switch(
                  value: _itemType == ItemType.task,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _itemType = value ? ItemType.task : ItemType.habit;
                          });
                        },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Title Field
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: _itemType == ItemType.habit
                    ? 'Habit Name'
                    : 'Task Name',
                hintText: _itemType == ItemType.habit
                    ? 'e.g., Morning Run, Read 10 pages'
                    : 'e.g., Buy groceries',
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),

            // Description Field (Habit only)
            if (_itemType == ItemType.habit) ...[
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'Add more details about this habit',
                ),
                maxLines: 3,
                minLines: 1,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
            ],

            // Category Field with Suggestions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Category (optional)', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(hintText: 'e.g., Work, Shopping'),
                  enabled: !_isLoading,
                  onChanged: (value) {
                    setState(() {}); // Trigger rebuild for suggestions
                  },
                ),
                // Suggestions chips
                if (_suggestedCategories.isNotEmpty &&
                    _categoryController.text.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _suggestedCategories.map((category) {
                        return InputChip(
                          label: Text(category),
                          onPressed: () {
                            _categoryController.text = category;
                            setState(() {});
                          },
                          onDeleted: null,
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Icon Selection Grid (Habit only)
            if (_itemType == ItemType.habit) ...[
              Text('Icon (optional)', style: theme.textTheme.labelMedium),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: IconMapping.availableIcons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 4),
                  itemBuilder: (context, index) {
                    final iconKey = IconMapping.availableIcons[index];
                    final isSelected = _selectedIconName == iconKey;

                    return GestureDetector(
                      onTap: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _selectedIconName = isSelected ? null : iconKey;
                              });
                            },
                      child: Container(
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? theme.colorScheme.primary.withValues(alpha: 0.2)
                              : theme.colorScheme.secondary.withValues(
                                  alpha: 0.08,
                                ),
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          IconMapping.getIcon(iconKey),
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.secondary,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Household Toggle (Habits & Tasks)
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Wspólne dla domowników',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                Switch(
                  value: _isHousehold,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() => _isHousehold = value);
                        },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Due Date Picker (Task only)
            if (_itemType == ItemType.task) ...[
              Row(
                children: [
                  Expanded(
                    child: Text('Due Date', style: theme.textTheme.bodyMedium),
                  ),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setState(() => _selectedDate = picked);
                            }
                          },
                    child: Text(
                      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Error Message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.error, width: 1),
                ),
                child: Text(
                  _errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleAddItem,
                    child: _isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            _itemType == ItemType.habit
                                ? 'Add Habit'
                                : 'Add Task',
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
