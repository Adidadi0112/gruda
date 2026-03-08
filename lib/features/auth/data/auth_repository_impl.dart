import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/profile.dart';
import 'auth_repository.dart';

/// Concrete implementation of AuthRepository using Supabase.
class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _supabase;

  AuthRepositoryImpl(this._supabase);

  @override
  Future<supabase.AuthResponse> signIn(String email, String password) async {
    print('\n[signIn] Attempting login for: $email');
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      print('[signIn] ✅ Login successful - User ID: ${response.user?.id}');
      return response;
    } catch (e) {
      print('[signIn] ❌ Login failed: $e');
      rethrow;
    }
  }

  @override
  Future<supabase.AuthResponse> signUp(
    String email,
    String password,
    String displayName,
  ) async {
    print(
      '\n[signUp] Attempting signup for: $email (displayName: $displayName)',
    );
    final authResponse = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );

    final userId = authResponse.user?.id;
    if (userId == null) {
      print('[signUp] ❌ Sign up failed: No user ID returned');
      throw Exception('Sign up failed: No user ID returned');
    }

    // DO NOT ADD ANY PROFILE INSERT CODE HERE.
    // Wait for the backend trigger to finish creating the profile.
    // The trigger should execute within 1-2 seconds, but we wait longer to be safe.
    print(
      '[signUp] ⏳ Waiting 2 seconds for database trigger to create profile...',
    );
    await Future.delayed(const Duration(seconds: 2));
    print('[signUp] ✅ Wait complete - Profile should now exist');

    return authResponse;
  }

  @override
  Future<void> signOut() async {
    print('\n[signOut] Signing out...');
    try {
      await _supabase.auth.signOut();
      print('[signOut] ✅ Signed out successfully');
    } catch (e) {
      print('[signOut] ❌ Error during sign out: $e');
      rethrow;
    }
  }

  @override
  Stream<supabase.AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  @override
  Future<Profile?> getCurrentProfile() async {
    final userId = _supabase.auth.currentUser?.id;
    print('\n[getCurrentProfile] Fetching profile for user: $userId');

    if (userId == null) {
      print('[getCurrentProfile] ❌ No user ID - returning null');
      return null;
    }

    try {
      print('[getCurrentProfile] 📋 Querying profiles table...');
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        print(
          '[getCurrentProfile] ⚠️ PROFILE NOT FOUND - Trigger may have failed or user is too new',
        );
        print(
          '[getCurrentProfile] ℹ️ Profile should be created by database trigger on signup',
        );
        // Return null and let router wait - profile may still be loading
        return null;
      }

      print('[getCurrentProfile] ✅ Response received: $response');

      final profile = Profile(
        id: response['id'] as String,
        displayName: response['display_name'] as String,
        householdId: response['household_id'] as String?,
      );

      print(
        '[getCurrentProfile] ✅ Profile created: id=${profile.id}, householdId=${profile.householdId}',
      );
      return profile;
    } catch (e) {
      print('[getCurrentProfile] ❌ Error: $e');
      return null;
    }
  }
}
