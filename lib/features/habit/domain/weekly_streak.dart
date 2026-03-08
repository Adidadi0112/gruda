/// Represents the completion status for a single day in the weekly streak.
class DayCompletion {
  final DateTime date;
  final bool isCompleted;

  const DayCompletion({required this.date, required this.isCompleted});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayCompletion &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode => date.hashCode ^ isCompleted.hashCode;
}

/// Weekly streak information for a specific habit (last 7 days).
class WeeklyStreak {
  final String habitId;
  final List<DayCompletion> days; // Ordered from 6 days ago to today

  const WeeklyStreak({required this.habitId, required this.days});

  /// Get completion rate as a percentage.
  double get completionRate {
    if (days.isEmpty) return 0;
    return days.where((d) => d.isCompleted).length / days.length;
  }

  /// Current streak length (consecutive days completed ending today).
  int get currentStreak {
    var count = 0;
    for (var i = days.length - 1; i >= 0; i--) {
      if (days[i].isCompleted) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyStreak &&
          runtimeType == other.runtimeType &&
          habitId == other.habitId &&
          days == other.days;

  @override
  int get hashCode => habitId.hashCode ^ days.hashCode;
}
