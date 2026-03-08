import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/habit.dart';
import 'habit_repository.dart';

/// Concrete implementation of HabitRepository using Supabase.
class HabitRepositoryImpl implements HabitRepository {
  final supabase.SupabaseClient _supabase;

  HabitRepositoryImpl(this._supabase);

  @override
  Stream<List<Habit>> getAllHabits() {
    final userId = _supabase.auth.currentUser?.id;
    print('[getAllHabits] Fetching all habits for user: $userId');

    if (userId == null) {
      print('[getAllHabits] ❌ No user ID - returning empty stream');
      return Stream.value([]);
    }

    return _supabase
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('owner_id', userId)
        .order('created_at', ascending: false)
        .map((data) {
          final habits = (data as List<dynamic>)
              .map((json) => _habitFromJson(json as Map<String, dynamic>))
              .toList();
          print('[getAllHabits] ✅ Received ${habits.length} habits');
          return habits;
        });
  }

  @override
  Future<Habit> createHabit({
    required String title,
    required String userId,
    String? description,
    String? category,
    String? iconName,
    bool isHousehold = false,
    String? householdId,
  }) async {
    print(
      '[createHabit] Creating habit: title=$title, category=$category, iconName=$iconName, isHousehold=$isHousehold',
    );

    try {
      final response = await _supabase
          .from('habits')
          .insert({
            'owner_id': userId,
            'title': title,
            'description': description,
            'category': category,
            'icon_name': iconName,
            'is_household': isHousehold,
            'household_id': householdId,
          })
          .select()
          .single();

      final habit = _habitFromJson(response);
      print('[createHabit] ✅ Habit created with ID: ${habit.id}');
      return habit;
    } catch (e) {
      print('[createHabit] ❌ Error creating habit: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    print('[deleteHabit] Deleting habit: $habitId');
    try {
      await _supabase.from('habits').delete().eq('id', habitId);
      print('[deleteHabit] ✅ Habit deleted');
    } catch (e) {
      print('[deleteHabit] ❌ Error deleting habit: $e');
      rethrow;
    }
  }

  @override
  Future<Habit> updateHabit(Habit habit) async {
    print('[updateHabit] Updating habit: ${habit.id}');
    try {
      final response = await _supabase
          .from('habits')
          .update({
            'title': habit.title,
            'description': habit.description,
            'category': habit.category,
            'is_household': habit.isHousehold,
            'completed_at': habit.completedAt?.toIso8601String(),
          })
          .eq('id', habit.id)
          .select()
          .single();

      final updatedHabit = _habitFromJson(response);
      print('[updateHabit] ✅ Habit updated');
      return updatedHabit;
    } catch (e) {
      print('[updateHabit] ❌ Error updating habit: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleHabitCompletion(
    String habitId, {
    required bool isCurrentlyCompleted,
  }) async {
    print(
      '[toggleHabitCompletion] Toggling habit: $habitId, isCurrentlyCompleted=$isCurrentlyCompleted',
    );
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('[toggleHabitCompletion] ❌ User not authenticated');
        throw Exception('User not authenticated');
      }

      // Format today's date as YYYY-MM-DD
      final today = DateTime.now().toIso8601String().split('T')[0];

      if (isCurrentlyCompleted) {
        // Delete the completion log
        print('[toggleHabitCompletion] Deleting habit log for today');
        await _supabase.from('habit_logs').delete().match({
          'habit_id': habitId,
          'user_id': userId,
          'completed_date': today,
        });
        print('[toggleHabitCompletion] ✅ Habit completion removed');
      } else {
        // Insert a completion log
        print('[toggleHabitCompletion] Inserting habit log for today');
        await _supabase.from('habit_logs').insert({
          'habit_id': habitId,
          'user_id': userId,
          'completed_date': today,
        });
        print('[toggleHabitCompletion] ✅ Habit marked as complete');
      }
    } catch (e) {
      print('[toggleHabitCompletion] ❌ Error toggling habit: $e');
      rethrow;
    }
  }

  @override
  Stream<List<String>> getTodayHabitLogs() {
    final userId = _supabase.auth.currentUser?.id;
    print('[getTodayHabitLogs] Fetching today\'s habit logs for user: $userId');

    if (userId == null) {
      print('[getTodayHabitLogs] ❌ No user ID - returning empty stream');
      return Stream.value([]);
    }

    final today = DateTime.now().toIso8601String().split('T')[0];
    print('[getTodayHabitLogs] Today\'s date: $today');

    return _supabase
        .from('habit_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) {
          print(
            '[getTodayHabitLogs] Raw data received: ${data.length} records',
          );
          final habitIds = (data as List<dynamic>)
              .where((json) {
                final completedDate = json['completed_date'] as String;
                final matches = completedDate == today;
                print(
                  '[getTodayHabitLogs] Record: completed_date=$completedDate, matches today=$matches',
                );
                return matches;
              })
              .map((json) => json['habit_id'] as String)
              .toList();
          print(
            '[getTodayHabitLogs] ✅ Received ${habitIds.length} completed habits for today: $habitIds',
          );
          return habitIds;
        });
  }

  @override
  Stream<List<String>> getUniqueCategories() {
    final userId = _supabase.auth.currentUser?.id;
    print('[getUniqueCategories] Fetching unique categories for user: $userId');

    if (userId == null) {
      print('[getUniqueCategories] ❌ No user ID - returning empty stream');
      return Stream.value([]);
    }

    return _supabase
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('owner_id', userId)
        .map((data) {
          final habits = (data as List<dynamic>)
              .map((json) => _habitFromJson(json as Map<String, dynamic>))
              .toList();

          // Extract unique non-null categories
          final categories =
              habits
                  .where((h) => h.category != null && h.category!.isNotEmpty)
                  .map((h) => h.category!)
                  .toSet()
                  .toList()
                ..sort();

          print(
            '[getUniqueCategories] ✅ Found ${categories.length} unique categories: $categories',
          );
          return categories;
        });
  }

  /// Helper to convert JSON from Supabase to Habit domain model.
  Habit _habitFromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] as String,
      userId: json['owner_id'] as String,
      householdId: json['household_id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      iconName: json['icon_name'] as String?,
      isHousehold: json['is_household'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
    );
  }
}
