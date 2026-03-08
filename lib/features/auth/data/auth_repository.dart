import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/profile.dart';

/// Abstract interface for authentication operations.
abstract class AuthRepository {
  /// Signs in a user with email and password.
  Future<supabase.AuthResponse> signIn(String email, String password);

  /// Signs up a new user with email and password.
  /// Returns the created Auth user and creates a profile in the database.
  Future<supabase.AuthResponse> signUp(
    String email,
    String password,
    String displayName,
  );

  /// Signs out the current user.
  Future<void> signOut();

  /// Stream of authentication state changes.
  Stream<supabase.AuthState> get authStateChanges;

  /// Gets the current authenticated user's profile.
  /// Returns null if not authenticated or profile doesn't exist.
  Future<Profile?> getCurrentProfile();
}
