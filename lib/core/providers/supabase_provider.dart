import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Provider for accessing the Supabase client instance.
///
/// This provider gives access to the initialized Supabase client
/// for database operations, authentication, and other Supabase services.
final supabaseProvider = Provider<supabase.SupabaseClient>((ref) {
  return supabase.Supabase.instance.client;
});
