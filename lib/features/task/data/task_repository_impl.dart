import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/task_item.dart';
import 'task_repository.dart';

/// Concrete implementation of TaskRepository using Supabase.
class TaskRepositoryImpl implements TaskRepository {
  final supabase.SupabaseClient _supabase;
  final String Function()
  getHouseholdId; // Callback to get household ID from Riverpod

  TaskRepositoryImpl(this._supabase, {required this.getHouseholdId});

  @override
  Stream<List<TaskItem>> watchTasksForDate(DateTime date) {
    final userId = _supabase.auth.currentUser?.id;
    final householdId = getHouseholdId();

    final dateStr = date.toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
    print(
      '[watchTasksForDate] Fetching tasks for date: $dateStr, householdId: $householdId',
    );

    if (userId == null || householdId.isEmpty) {
      print(
        '[watchTasksForDate] ❌ Missing user ID or household ID - returning empty stream',
      );
      return Stream.value([]);
    }

    return _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('household_id', householdId)
        .map((data) {
          print(
            '[watchTasksForDate] Raw data received: ${data.length} records',
          );
          final tasks = (data as List<dynamic>)
              .where((json) {
                final dueDate = json['due_date'] as String;
                final matches = dueDate == dateStr;
                return matches;
              })
              .map((json) => _taskFromJson(json as Map<String, dynamic>))
              .toList();
          print(
            '[watchTasksForDate] ✅ Received ${tasks.length} tasks for date: $dateStr',
          );
          return tasks;
        });
  }

  @override
  Future<void> addTask({
    required String title,
    String? category,
    required DateTime dueDate,
    required bool isHousehold,
  }) async {
    print(
      '[addTask] Adding task: title=$title, dueDate=$dueDate, isHousehold=$isHousehold',
    );
    try {
      final userId = _supabase.auth.currentUser?.id;
      final householdId = getHouseholdId();

      if (userId == null || householdId.isEmpty) {
        print('[addTask] ❌ User not authenticated or not in a household');
        throw Exception('User must be authenticated and in a household');
      }

      final dueDateStr = dueDate.toIso8601String().split(
        'T',
      )[0]; // Format: YYYY-MM-DD

      await _supabase.from('tasks').insert({
        'title': title,
        'category': category,
        'due_date': dueDateStr,
        'owner_id': userId,
        'household_id': householdId,
        'is_completed': false,
        'is_household': isHousehold,
      });

      print('[addTask] ✅ Task added successfully');
    } catch (e) {
      print('[addTask] ❌ Error adding task: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    print(
      '[toggleTaskCompletion] Toggling task: $taskId, isCompleted=$isCompleted',
    );
    try {
      await _supabase
          .from('tasks')
          .update({'is_completed': !isCompleted})
          .eq('id', taskId);

      print('[toggleTaskCompletion] ✅ Task updated');
    } catch (e) {
      print('[toggleTaskCompletion] ❌ Error toggling task: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateTask(TaskItem task) async {
    print('[updateTask] Updating task: ${task.id}');
    try {
      final dueDateStr = task.dueDate.toIso8601String().split(
        'T',
      )[0]; // Format: YYYY-MM-DD

      await _supabase
          .from('tasks')
          .update({
            'title': task.title,
            'category': task.category,
            'due_date': dueDateStr,
            'is_household': task.isHousehold,
          })
          .eq('id', task.id);

      print('[updateTask] ✅ Task updated successfully');
    } catch (e) {
      print('[updateTask] ❌ Error updating task: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    print('[deleteTask] Deleting task: $taskId');
    try {
      await _supabase.from('tasks').delete().eq('id', taskId);

      print('[deleteTask] ✅ Task deleted successfully');
    } catch (e) {
      print('[deleteTask] ❌ Error deleting task: $e');
      rethrow;
    }
  }

  /// Helper to convert JSON from Supabase to TaskItem domain model.
  TaskItem _taskFromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      ownerId: json['owner_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String?,
      dueDate: DateTime.parse(json['due_date'] as String),
      isCompleted: json['is_completed'] as bool? ?? false,
      isHousehold: json['is_household'] as bool? ?? false,
    );
  }
}
