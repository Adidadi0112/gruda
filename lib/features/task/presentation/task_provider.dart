import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/supabase_provider.dart';
import '../../auth/presentation/auth_provider.dart';
import '../../habit/presentation/habit_provider.dart';
import '../data/task_repository.dart';
import '../data/task_repository_impl.dart';
import '../domain/task_item.dart';

part 'task_provider.g.dart';

/// Provider for the TaskRepository instance.
@riverpod
TaskRepository taskRepository(TaskRepositoryRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final profileAsync = ref.watch(currentProfileProvider);

  // Get household ID from profile
  String getHouseholdId() {
    if (profileAsync.hasValue) {
      return profileAsync.value?.householdId ?? '';
    }
    return '';
  }

  return TaskRepositoryImpl(supabase, getHouseholdId: getHouseholdId);
}

/// StreamProvider for today's tasks.
@riverpod
Stream<List<TaskItem>> todayTasksProvider(TodayTasksProviderRef ref) {
  print('[todayTasksProvider] Fetching today\'s tasks...');
  final taskRepo = ref.watch(taskRepositoryProvider);
  final today = DateTime.now();
  return taskRepo.watchTasksForDate(today).map((tasks) {
    print('[todayTasksProvider] ✅ Received ${tasks.length} tasks for today');
    return tasks;
  });
}

/// Filtered tasks provider based on global filter and hideCompleted setting.
/// If 'Wszystkie': return all tasks.
/// If 'Wspólne': return only household tasks.
/// If 'Prywatne': return only personal (non-household) tasks.
/// Else: return tasks matching the selected category.
/// Additionally, hides completed tasks if hideCompleted is true, or sorts them to bottom.
@riverpod
Stream<List<TaskItem>> filteredTasks(FilteredTasksRef ref) {
  final tasksAsync = ref.watch(todayTasksProviderProvider);
  final globalFilter = ref.watch(globalActiveFilterProvider);
  final hideCompleted = ref.watch(hideCompletedTasksProvider);

  return tasksAsync.when(
    data: (tasks) {
      print(
        '[filteredTasks] Filtering ${tasks.length} tasks with filter: $globalFilter, hideCompleted: $hideCompleted',
      );
      final result = _applyTaskFilter(tasks, globalFilter, hideCompleted);
      print('[filteredTasks] ✅ Result: ${result.length} tasks after filtering');
      return Stream.value(result);
    },
    loading: () {
      print('[filteredTasks] Loading...');
      return Stream.value([]);
    },
    error: (error, stackTrace) {
      print('[filteredTasks] ❌ Error: $error');
      return Stream.value([]);
    },
  );
}

List<TaskItem> _applyTaskFilter(
  List<TaskItem> tasks,
  String filter,
  bool hideCompleted,
) {
  // Apply global filter first
  List<TaskItem> filtered;
  if (filter == 'Wszystkie') {
    filtered = tasks;
  } else if (filter == 'Wspólne') {
    filtered = tasks.where((t) => t.isHousehold).toList();
  } else if (filter == 'Prywatne') {
    filtered = tasks.where((t) => !t.isHousehold).toList();
  } else {
    // Filter by category
    filtered = tasks.where((t) => t.category == filter).toList();
  }

  // Apply hideCompleted and sorting
  if (hideCompleted) {
    // Hide completed tasks
    filtered = filtered.where((t) => !t.isCompleted).toList();
  } else {
    // Sort: incomplete first, completed at bottom
    filtered.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return 0; // Maintain order for same completion status
      }
      return a.isCompleted
          ? 1
          : -1; // Incomplete (false) comes before completed (true)
    });
  }

  return filtered;
}

/// FutureProvider for adding a new task.
@riverpod
Future<void> addTask(
  AddTaskRef ref, {
  required String title,
  String? category,
  required DateTime dueDate,
  required bool isHousehold,
}) async {
  print(
    '[addTask] Called: title=$title, dueDate=$dueDate, isHousehold=$isHousehold',
  );
  try {
    final taskRepo = ref.watch(taskRepositoryProvider);
    await taskRepo.addTask(
      title: title,
      category: category,
      dueDate: dueDate,
      isHousehold: isHousehold,
    );

    // Refresh today's tasks
    ref.invalidate(todayTasksProviderProvider);

    print('[addTask] ✅ Task added successfully');
  } catch (e) {
    print('[addTask] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for toggling a task's completion status.
@riverpod
Future<void> toggleTask(
  ToggleTaskRef ref,
  String taskId,
  bool isCompleted,
) async {
  print('[toggleTask] Called for taskId: $taskId, isCompleted=$isCompleted');
  try {
    final taskRepo = ref.watch(taskRepositoryProvider);
    await taskRepo.toggleTaskCompletion(taskId, isCompleted);

    // Refresh today's tasks
    ref.invalidate(todayTasksProviderProvider);

    print('[toggleTask] ✅ Task toggled');
  } catch (e) {
    print('[toggleTask] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for updating a task.
@riverpod
Future<void> updateTask(UpdateTaskRef ref, TaskItem task) async {
  print('[updateTask] Called for taskId: ${task.id}');
  try {
    final taskRepo = ref.watch(taskRepositoryProvider);
    await taskRepo.updateTask(task);

    // Refresh today's tasks
    ref.invalidate(todayTasksProviderProvider);

    print('[updateTask] ✅ Task updated successfully');
  } catch (e) {
    print('[updateTask] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for deleting a task.
@riverpod
Future<void> deleteTask(DeleteTaskRef ref, String taskId) async {
  print('[deleteTask] Called for taskId: $taskId');
  try {
    final taskRepo = ref.watch(taskRepositoryProvider);
    await taskRepo.deleteTask(taskId);

    // Refresh today's tasks
    ref.invalidate(todayTasksProviderProvider);

    print('[deleteTask] ✅ Task deleted successfully');
  } catch (e) {
    print('[deleteTask] ❌ Error: $e');
    rethrow;
  }
}
