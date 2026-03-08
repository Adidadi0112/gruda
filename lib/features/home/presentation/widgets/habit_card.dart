import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:intl/intl.dart';

import '../../../habit/domain/habit_item_state.dart';
import '../../../habit/presentation/habit_provider.dart';

/// HabitCard - Widget displaying a single habit.
class HabitCard extends ConsumerWidget {
  final HabitItemState habitItemState;

  const HabitCard({super.key, required this.habitItemState});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habit = habitItemState.habit;
    final isCompletedToday = habitItemState.isCompletedToday;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Title + Category
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title,
                        style: theme.textTheme.titleLarge,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (habit.category != null && habit.category!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            habit.category!,
                            style: theme.textTheme.labelMedium,
                          ),
                        ),
                    ],
                  ),
                ),
                // Complete Button
                IconButton(
                  icon: Icon(
                    isCompletedToday
                        ? LucideIcons.checkCircle2
                        : LucideIcons.circle,
                    color: isCompletedToday
                        ? theme.colorScheme.primary
                        : theme.colorScheme.secondary,
                  ),
                  onPressed: () {
                    ref.read(completeHabitProvider(habit.id));
                  },
                  tooltip: isCompletedToday
                      ? 'Ukończone dzisiaj'
                      : 'Oznacz jako ukończone',
                ),
              ],
            ),
            // Description (if present)
            if (habit.description != null && habit.description!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                habit.description!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            // Footer: Metadata
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      habit.isHousehold ? LucideIcons.users : LucideIcons.user,
                      size: 14,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      habit.isHousehold ? 'Wspólne' : 'Osobiste',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Utworzono ${DateFormat('d MMM').format(habit.createdAt)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ],
            ),
            // Completion Status
            if (isCompletedToday) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '✓ Ukończone dzisiaj',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
