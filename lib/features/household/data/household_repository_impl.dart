import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/household.dart';
import 'household_repository.dart';

/// Concrete implementation of HouseholdRepository using Supabase.
class HouseholdRepositoryImpl implements HouseholdRepository {
  final supabase.SupabaseClient _supabase;

  HouseholdRepositoryImpl(this._supabase);

  static const String _inviteCodeCharacters =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  static const int _inviteCodeLength = 6;

  /// Generates a random 6-character invite code.
  String _generateInviteCode() {
    final random = Random();
    return List.generate(
      _inviteCodeLength,
      (_) =>
          _inviteCodeCharacters[random.nextInt(_inviteCodeCharacters.length)],
    ).join();
  }

  @override
  Future<Household> createHousehold(String name) async {
    print('\n[createHousehold] Starting household creation for: $name');

    final userId = _supabase.auth.currentUser?.id;
    print('[createHousehold] Current user ID: $userId');

    if (userId == null) {
      print('[createHousehold] ❌ User not authenticated');
      throw Exception('User not authenticated');
    }

    // Generate unique invite code
    print('[createHousehold] 🔐 Generating unique invite code...');
    String inviteCode;
    bool isUnique = false;
    int attempts = 0;
    do {
      inviteCode = _generateInviteCode();
      attempts++;
      final existing = await _supabase
          .from('households')
          .select('id')
          .eq('invite_code', inviteCode)
          .maybeSingle();
      isUnique = existing == null;
      print(
        '[createHousehold] Attempt $attempts: Code=$inviteCode, Unique=$isUnique',
      );
    } while (!isUnique);

    print('[createHousehold] ✅ Generated invite code: $inviteCode');

    // Create household
    print('[createHousehold] 📝 Inserting household into database...');
    final response = await _supabase
        .from('households')
        .insert({'name': name, 'invite_code': inviteCode})
        .select()
        .single();

    final householdId = response['id'] as String;
    print('[createHousehold] ✅ Household created with ID: $householdId');

    // Update user's profile with household_id
    print('[createHousehold] 📋 Updating user profile with household_id...');
    await _supabase
        .from('profiles')
        .update({'household_id': householdId})
        .eq('id', userId);
    print('[createHousehold] ✅ Profile updated successfully');

    final household = Household(
      id: householdId,
      name: response['name'] as String,
      inviteCode: response['invite_code'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );

    print('[createHousehold] ✅ Household creation complete: $household');
    return household;
  }

  @override
  Future<Household> joinHousehold(String inviteCode) async {
    print(
      '\n[joinHousehold] Attempting to join household with code: $inviteCode',
    );

    final userId = _supabase.auth.currentUser?.id;
    print('[joinHousehold] Current user ID: $userId');

    if (userId == null) {
      print('[joinHousehold] ❌ User not authenticated');
      throw Exception('User not authenticated');
    }

    // Fetch household by invite code
    print(
      '[joinHousehold] 🔍 Searching for household with code: ${inviteCode.toUpperCase()}',
    );
    final response = await _supabase
        .from('households')
        .select()
        .eq('invite_code', inviteCode.toUpperCase())
        .maybeSingle();

    if (response == null) {
      print(
        '[joinHousehold] ❌ Household not found with invite code: $inviteCode',
      );
      throw Exception('Household not found with invite code: $inviteCode');
    }

    print(
      '[joinHousehold] ✅ Household found: ${response['name']} (ID: ${response['id']})',
    );

    final householdId = response['id'] as String;

    // Update user's profile with household_id
    print(
      '[joinHousehold] 📋 Updating user profile with household_id: $householdId',
    );
    await _supabase
        .from('profiles')
        .update({'household_id': householdId})
        .eq('id', userId);
    print('[joinHousehold] ✅ Profile updated successfully');

    final household = Household(
      id: householdId,
      name: response['name'] as String,
      inviteCode: response['invite_code'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );

    print('[joinHousehold] ✅ Successfully joined household: ${household.name}');
    return household;
  }
}
