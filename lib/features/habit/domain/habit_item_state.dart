import 'habit.dart';

/// Combined state representing a habit and its completion status for today.
class HabitItemState {
  final Habit habit;
  final bool isCompletedToday;

  const HabitItemState({required this.habit, required this.isCompletedToday});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitItemState &&
          runtimeType == other.runtimeType &&
          habit == other.habit &&
          isCompletedToday == other.isCompletedToday;

  @override
  int get hashCode => habit.hashCode ^ isCompletedToday.hashCode;

  @override
  String toString() =>
      'HabitItemState(habit: ${habit.id}, isCompletedToday: $isCompletedToday)';
}
