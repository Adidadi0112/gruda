import '../domain/task_item.dart';

/// Abstract interface for task operations.
abstract class TaskRepository {
  /// Watch tasks for a specific date.
  /// Filters by due_date and current user's household_id.
  Stream<List<TaskItem>> watchTasksForDate(DateTime date);

  /// Add a new task.
  /// Automatically injects owner_id and household_id from the current user.
  Future<void> addTask({
    required String title,
    String? category,
    required DateTime dueDate,
    required bool isHousehold,
  });

  /// Update an existing task.
  Future<void> updateTask(TaskItem task);

  /// Delete a task by ID.
  Future<void> deleteTask(String taskId);

  /// Toggle a task's completion status.
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted);
}
