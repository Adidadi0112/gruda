import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../habit/presentation/habit_provider.dart';
import '../../../meal/presentation/screens/shopping_list_screen.dart';
import '../../../task/domain/task_item.dart';
import '../../../task/presentation/task_provider.dart';
import '../widgets/add_habit_bottom_sheet.dart';
import '../widgets/modern_habit_card.dart';

/// Compact task tile for dashboard display.
class CompactTaskTile extends StatelessWidget {
  final TaskItem task;
  final WidgetRef ref;

  const CompactTaskTile({super.key, required this.task, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.surfaceContainerHighest,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) {
              ref.read(toggleTaskProvider(task.id, task.isCompleted));
            },
          ),
          // Title
          Expanded(
            child: Text(
              task.title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: task.isCompleted
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.onSurface,
                decoration: task.isCompleted
                    ? TextDecoration.lineThrough
                    : null,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Household/Personal label
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.isHousehold ? 'Wspólne' : 'Osobiste',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// HomeScreen - Main Habit Tracker screen with dynamic categories.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _showAddHabitModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddHabitBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final globalFilter = ref.watch(globalActiveFilterProvider);
    final hideCompleted = ref.watch(hideCompletedTasksProvider);
    final availableFiltersAsync = ref.watch(availableHabitFiltersProvider);
    final filteredHabitsAsync = ref.watch(filteredHabitsProvider);
    final filteredTasksAsync = ref.watch(filteredTasksProvider);
    final weeklyStreaksAsync = ref.watch(weeklyStreaksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kokpit'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingCart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShoppingListScreen(),
                ),
              );
            },
            tooltip: 'Lista Zakupów',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ GLOBAL FILTER CHIPS ============
            availableFiltersAsync.when(
              data: (filters) => SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    final isSelected = filter == globalFilter;

                    return ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(globalActiveFilterProvider.notifier).state =
                            filter;
                      },
                    );
                  },
                ),
              ),
              loading: () => SizedBox(
                height: 50,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              error: (error, stack) => SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    'Błąd ładowania filtrów',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ),

            // ============ TASKS SECTION ============
            filteredTasksAsync.when(
              data: (tasks) {
                // Get the unfiltered task count for the header
                // We need to watch todayTasksProvider just for the count
                final todayTasksAsync = ref.watch(todayTasksProviderProvider);
                final completedCount = todayTasksAsync.maybeWhen(
                  data: (allTasks) =>
                      allTasks.where((t) => t.isCompleted).length,
                  orElse: () => 0,
                );
                final totalCount = todayTasksAsync.maybeWhen(
                  data: (allTasks) => allTasks.length,
                  orElse: () => 0,
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with counter and hide completed toggle
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Dzisiejsze Zadania (${totalCount - completedCount}/$totalCount)',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Ukryj zrobione',
                                  style: theme.textTheme.labelSmall,
                                ),
                                const SizedBox(width: 4),
                                Switch(
                                  value: hideCompleted,
                                  onChanged: (value) {
                                    ref
                                            .read(
                                              hideCompletedTasksProvider
                                                  .notifier,
                                            )
                                            .state =
                                        value;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        if (tasks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: Text(
                                hideCompleted && totalCount > 0
                                    ? 'Wszystkie zadania ukończone!'
                                    : 'Brak zadań na dzisiaj',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ),
                          )
                        else
                          Column(
                            children: List.generate(tasks.length, (index) {
                              final task = tasks[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: CompactTaskTile(task: task, ref: ref),
                              );
                            }),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                );
              },
              loading: () => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dzisiejsze Zadania',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Błąd ładowania zadań',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),

            // ============ HABITS SECTION ============
            filteredHabitsAsync.when(
              data: (habits) {
                if (habits.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.checkCircle,
                            size: 48,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Brak nawyków',
                            style: theme.textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Zacznij od dodania nowego nawyku',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 12,
                      ),
                      child: Text(
                        'Twoje Nawyki',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Habits list with streak data
                    weeklyStreaksAsync.when(
                      data: (streaks) {
                        return Column(
                          children: List.generate(habits.length, (index) {
                            final habitState = habits[index];
                            final streak = streaks[habitState.habit.id];

                            return ModernHabitCard(
                              habitItemState: habitState,
                              weeklyStreak: streak,
                            );
                          }),
                        );
                      },
                      loading: () => Column(
                        children: List.generate(habits.length, (index) {
                          final habitState = habits[index];

                          return ModernHabitCard(
                            habitItemState: habitState,
                            weeklyStreak: null,
                          );
                        }),
                      ),
                      error: (error, stack) {
                        return Column(
                          children: List.generate(habits.length, (index) {
                            final habitState = habits[index];

                            return ModernHabitCard(
                              habitItemState: habitState,
                              weeklyStreak: null,
                            );
                          }),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                );
              },
              loading: () => Padding(
                padding: const EdgeInsets.all(16),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Błąd ładowania nawyków: $error',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitModal(context),
        tooltip: 'Dodaj Nawyk lub Zadanie',
        child: Icon(LucideIcons.plus),
      ),
    );
  }
}
