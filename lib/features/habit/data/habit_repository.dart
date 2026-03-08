import '../domain/habit.dart';

/// Abstract interface for habit operations.
abstract class HabitRepository {
  /// Get a stream of all habits for the current user.
  Stream<List<Habit>> getAllHabits();

  /// Create a new habit.
  Future<Habit> createHabit({
    required String title,
    required String userId,
    String? description,
    String? category,
    String? iconName,
    bool isHousehold = false,
    String? householdId,
  });

  /// Delete a habit by ID.
  Future<void> deleteHabit(String habitId);

  /// Update an existing habit.
  Future<Habit> updateHabit(Habit habit);

  /// Toggle a habit's completion status for today.
  /// If [isCurrentlyCompleted] is true, removes the completion log.
  /// If [isCurrentlyCompleted] is false, adds a completion log.
  Future<void> toggleHabitCompletion(
    String habitId, {
    required bool isCurrentlyCompleted,
  });

  /// Get today's habit completion logs for the current user.
  Stream<List<String>> getTodayHabitLogs();

  /// Get a list of unique categories from user's habits.
  Stream<List<String>> getUniqueCategories();
}
