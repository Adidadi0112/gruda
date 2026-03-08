import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/utils/icon_mapping.dart';
import '../../../habit/domain/habit_item_state.dart';
import '../../../habit/domain/weekly_streak.dart';
import '../../../habit/presentation/habit_provider.dart';

/// Modern compact habit card displaying habit info and 7-day streak.
class ModernHabitCard extends ConsumerWidget {
  final HabitItemState habitItemState;
  final WeeklyStreak? weeklyStreak;

  const ModernHabitCard({
    super.key,
    required this.habitItemState,
    this.weeklyStreak,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final habit = habitItemState.habit;
    final isCompletedToday = habitItemState.isCompletedToday;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon, Title, Household Label, Completion Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon with background
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  ),
                  child: Icon(
                    IconMapping.getIcon(habit.iconName),
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    habit.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Household/Personal Label
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    habit.isHousehold ? 'Wspólne' : 'Osobiste',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Circular completion button
                CircularCompletionButton(
                  isCompleted: isCompletedToday,
                  onPressed: () {
                    ref.read(completeHabitProvider(habit.id));
                  },
                ),
              ],
            ),
            // Row 2: 7-day streak dots
            if (weeklyStreak != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(weeklyStreak!.days.length, (index) {
                  final day = weeklyStreak!.days[index];
                  final isToday = index == weeklyStreak!.days.length - 1;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _StreakDot(
                      isCompleted: day.isCompleted,
                      isToday: isToday,
                      theme: theme,
                    ),
                  );
                }),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Custom circular button for marking habit completion.
class CircularCompletionButton extends StatelessWidget {
  final bool isCompleted;
  final VoidCallback onPressed;

  const CircularCompletionButton({
    super.key,
    required this.isCompleted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(
            isCompleted ? LucideIcons.check : LucideIcons.circle,
            color: isCompleted
                ? theme.colorScheme.primary
                : theme.colorScheme.tertiary,
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Small dot indicator for daily completion in weekly streak.
class _StreakDot extends StatelessWidget {
  final bool isCompleted;
  final bool isToday;
  final ThemeData theme;

  const _StreakDot({
    required this.isCompleted,
    required this.isToday,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isCompleted ? theme.colorScheme.primary : null;

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dotColor?.withValues(alpha: 0.2),
        border: Border.all(
          color: dotColor ?? theme.colorScheme.tertiary,
          width: isToday ? 2 : 1,
        ),
      ),
      child: isCompleted
          ? Icon(LucideIcons.check, size: 12, color: theme.colorScheme.primary)
          : null,
    );
  }
}
