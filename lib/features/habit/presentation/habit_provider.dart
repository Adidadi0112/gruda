import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/supabase_provider.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/habit_repository.dart';
import '../data/habit_repository_impl.dart';
import '../domain/habit.dart';
import '../domain/habit_item_state.dart';
import '../domain/weekly_streak.dart';

part 'habit_provider.g.dart';

/// Provider for the HabitRepository instance.
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return HabitRepositoryImpl(supabase);
});

/// StreamProvider for all habits of the current user.
@riverpod
Stream<List<Habit>> habitsList(HabitsListRef ref) {
  final habitRepo = ref.watch(habitRepositoryProvider);
  return habitRepo.getAllHabits();
}

/// StreamProvider for today's completed habit IDs.
@riverpod
Stream<List<String>> todayHabitLogs(TodayHabitLogsRef ref) {
  print('[todayHabitLogsProvider] Watching todayHabitLogs...');
  final habitRepo = ref.watch(habitRepositoryProvider);
  return habitRepo.getTodayHabitLogs().map((logs) {
    print('[todayHabitLogsProvider] ✅ Received: $logs');
    return logs;
  });
}

/// Computed provider that combines habits with their completion status.
@riverpod
Stream<List<HabitItemState>> habitItemStates(HabitItemStatesRef ref) {
  final habitsAsync = ref.watch(habitsListProvider);
  final todayLogsAsync = ref.watch(todayHabitLogsProvider);

  return habitsAsync.when(
    data: (habits) => todayLogsAsync.when(
      data: (todayHabitIds) {
        print(
          '[habitItemStates] Combining ${habits.length} habits with ${todayHabitIds.length} completed today: $todayHabitIds',
        );
        final result = habits.map((habit) {
          final isCompleted = todayHabitIds.contains(habit.id);
          print(
            '[habitItemStates] Habit ${habit.title}: isCompletedToday=$isCompleted',
          );
          return HabitItemState(habit: habit, isCompletedToday: isCompleted);
        }).toList();
        return Stream.value(result);
      },
      loading: () => Stream.value([]),
      error: (err, __) {
        print('[habitItemStates] ❌ Error in todayLogsAsync: $err');
        return Stream.value([]);
      },
    ),
    loading: () => Stream.value([]),
    error: (err, __) {
      print('[habitItemStates] ❌ Error in habitsAsync: $err');
      return Stream.value([]);
    },
  );
}

/// StateProvider for the global active filter.
/// Options: 'Wszystkie' (All), 'Wspólne' (Household), 'Prywatne' (Private), or a category name.
final globalActiveFilterProvider = StateProvider<String>((_) => 'Wszystkie');

/// StateProvider for hiding completed tasks.
/// Default is TRUE (hide completed tasks).
final hideCompletedTasksProvider = StateProvider<bool>((_) => true);

/// StreamProvider for unique categories from user's habits.
@riverpod
Stream<List<String>> uniqueCategories(UniqueCategoriesRef ref) {
  final habitRepo = ref.watch(habitRepositoryProvider);
  return habitRepo.getUniqueCategories();
}

/// Computed provider that returns all available filter options.
/// Combines 'Wszystkie', 'Wspólne', 'Prywatne' + unique categories.
@riverpod
Stream<List<String>> availableHabitFilters(AvailableHabitFiltersRef ref) {
  final categoriesAsync = ref.watch(uniqueCategoriesProvider);

  return categoriesAsync.when(
    data: (categories) =>
        Stream.value(['Wszystkie', 'Wspólne', 'Prywatne', ...categories]),
    loading: () => Stream.value(['Wszystkie', 'Wspólne', 'Prywatne']),
    error: (_, __) => Stream.value(['Wszystkie', 'Wspólne', 'Prywatne']),
  );
}

/// Filtered habits provider based on global filter and hideCompleted setting.
/// If 'Wszystkie': return all habits.
/// If 'Wspólne': return only household habits.
/// If 'Prywatne': return only personal (non-household) habits.
/// Else: return habits matching the selected category.
/// Additionally, sorts habits to show active ones first and completed at bottom.
@riverpod
Stream<List<HabitItemState>> filteredHabits(FilteredHabitsRef ref) {
  final habitItemStatesAsync = ref.watch(habitItemStatesProvider);
  final globalFilter = ref.watch(globalActiveFilterProvider);
  final hideCompleted = ref.watch(hideCompletedTasksProvider);

  return habitItemStatesAsync.when(
    data: (habitItemStates) {
      print(
        '[filteredHabits] Filtering ${habitItemStates.length} habits with filter: $globalFilter, hideCompleted: $hideCompleted',
      );
      final result = _applyHabitFilter(
        habitItemStates,
        globalFilter,
        hideCompleted,
      );
      print(
        '[filteredHabits] ✅ Result: ${result.length} habits after filtering',
      );
      return Stream.value(result);
    },
    loading: () {
      print('[filteredHabits] Loading...');
      return Stream.value([]);
    },
    error: (error, stackTrace) {
      print('[filteredHabits] ❌ Error: $error');
      return Stream.value([]);
    },
  );
}

List<HabitItemState> _applyHabitFilter(
  List<HabitItemState> habits,
  String filter,
  bool hideCompleted,
) {
  // Apply global filter first
  List<HabitItemState> filtered;
  if (filter == 'Wszystkie') {
    filtered = habits;
  } else if (filter == 'Wspólne') {
    filtered = habits.where((hs) => hs.habit.isHousehold).toList();
  } else if (filter == 'Prywatne') {
    filtered = habits.where((hs) => !hs.habit.isHousehold).toList();
  } else {
    // Filter by category
    filtered = habits.where((hs) => hs.habit.category == filter).toList();
  }

  // Apply hideCompleted and sorting
  if (hideCompleted) {
    // Hide completed habits
    filtered = filtered.where((h) => !h.isCompletedToday).toList();
  } else {
    // Sort: active first, completed at bottom
    filtered.sort((a, b) {
      if (a.isCompletedToday == b.isCompletedToday) {
        return 0; // Maintain order for same completion status
      }
      return a.isCompletedToday
          ? 1
          : -1; // Active (false) comes before completed (true)
    });
  }

  return filtered;
}

/// FutureProvider for creating a new habit.
@riverpod
Future<Habit> createHabit(
  CreateHabitRef ref, {
  required String title,
  String? description,
  String? category,
  String? iconName,
  bool isHousehold = false,
}) async {
  print(
    '[habitProvider.createHabit] Called: title=$title, category=$category, iconName=$iconName',
  );

  try {
    final habitRepo = ref.watch(habitRepositoryProvider);
    final supabase = ref.watch(supabaseProvider);

    // Get current user ID
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      print('[habitProvider.createHabit] ❌ User not authenticated');
      throw Exception('User not authenticated');
    }

    // Get current user's household ID from profile
    final profile = await ref.read(currentProfileProvider.future);
    final householdId = profile?.householdId;

    if (householdId == null || householdId.isEmpty) {
      print('[habitProvider.createHabit] ❌ User not in a household');
      throw Exception('User must be part of a household to create habits');
    }

    print(
      '[habitProvider.createHabit] userId=$userId, householdId=$householdId',
    );

    final habit = await habitRepo.createHabit(
      title: title,
      userId: userId,
      description: description,
      category: category,
      iconName: iconName,
      isHousehold: isHousehold,
      householdId: householdId,
    );

    // Refresh the habits list to include the new habit
    ref.invalidate(habitsListProvider);

    print('[habitProvider.createHabit] ✅ Habit created: ${habit.id}');
    return habit;
  } catch (e) {
    print('[habitProvider.createHabit] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for deleting a habit.
@riverpod
Future<void> deleteHabit(DeleteHabitRef ref, String habitId) async {
  print('[habitProvider.deleteHabit] Called for habitId: $habitId');

  try {
    final habitRepo = ref.watch(habitRepositoryProvider);
    await habitRepo.deleteHabit(habitId);
    print('[habitProvider.deleteHabit] ✅ Habit deleted');
  } catch (e) {
    print('[habitProvider.deleteHabit] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for completing a habit.
@riverpod
Future<void> completeHabit(CompleteHabitRef ref, String habitId) async {
  print('[habitProvider.completeHabit] Called for habitId: $habitId');

  try {
    final habitRepo = ref.watch(habitRepositoryProvider);

    // Get current completion status from todayHabitLogs
    final todayLogsAsync = ref.watch(todayHabitLogsProvider);
    bool isCurrentlyCompleted = false;

    // Determine current state
    if (todayLogsAsync.hasValue) {
      final todayLogs = todayLogsAsync.value!;
      isCurrentlyCompleted = todayLogs.contains(habitId);
    }

    print(
      '[habitProvider.completeHabit] Current completion status: $isCurrentlyCompleted',
    );

    // Toggle the completion status
    await habitRepo.toggleHabitCompletion(
      habitId,
      isCurrentlyCompleted: isCurrentlyCompleted,
    );

    // Refresh the logs and weekly streaks
    ref.invalidate(todayHabitLogsProvider);
    ref.invalidate(weeklyStreaksProvider);

    print('[habitProvider.completeHabit] ✅ Habit toggled');
  } catch (e) {
    print('[habitProvider.completeHabit] ❌ Error: $e');
    rethrow;
  }
}

/// StreamProvider for fetching weekly habit streaks from the habit_progress_7_days view.
@riverpod
Stream<Map<String, WeeklyStreak>> weeklyStreaks(WeeklyStreaksRef ref) {
  final supabase = ref.watch(supabaseProvider);
  final userId = supabase.auth.currentUser?.id;

  print('[weeklyStreaks] Fetching streaks for user: $userId');

  if (userId == null) {
    print('[weeklyStreaks] ❌ No user ID - returning empty map');
    return Stream.value({});
  }

  return supabase
      .from('habit_progress_7_days')
      .stream(primaryKey: ['habit_id', 'completed_date'])
      .eq('user_id', userId)
      .map((data) {
        print('[weeklyStreaks] Raw data received: ${data.length} records');

        final Map<String, Set<String>> habitDates = {};

        // Group by habit_id
        for (final record in data as List<dynamic>) {
          final habitId = record['habit_id'] as String;
          final completedDate = record['completed_date'] as String;

          if (!habitDates.containsKey(habitId)) {
            habitDates[habitId] = {};
          }
          habitDates[habitId]!.add(completedDate);
        }

        // Build WeeklyStreak objects
        final Map<String, WeeklyStreak> streaks = {};
        final now = DateTime.now();

        habitDates.forEach((habitId, completedDates) {
          final days = <DayCompletion>[];

          // Generate 7 days: from 6 days ago to today
          for (var i = 6; i >= 0; i--) {
            final date = now.subtract(Duration(days: i));
            final dateStr = date.toIso8601String().split('T')[0]; // YYYY-MM-DD
            final isCompleted = completedDates.contains(dateStr);

            days.add(DayCompletion(date: date, isCompleted: isCompleted));
          }

          streaks[habitId] = WeeklyStreak(habitId: habitId, days: days);
        });

        print(
          '[weeklyStreaks] ✅ Generated streaks for ${streaks.length} habits',
        );
        return streaks;
      });
}
