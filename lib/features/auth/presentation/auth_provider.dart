import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

import '../../../core/providers/supabase_provider.dart';
import '../data/auth_repository.dart';
import '../data/auth_repository_impl.dart';
import '../domain/profile.dart';

part 'auth_provider.g.dart';

/// Provider for the AuthRepository instance.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return AuthRepositoryImpl(supabase);
});

/// StreamProvider for authentication state changes.
@riverpod
Stream<AuthState> authState(AuthStateRef ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  return authRepo.authStateChanges.map((event) {
    print(
      '[authState] Auth event: event=${event.event}, userId=${event.session?.user.id}',
    );
    return event;
  });
}

/// FutureProvider for the current user's profile.
/// Re-fetches whenever the auth state changes (user login/logout).
@riverpod
Future<Profile?> currentProfile(CurrentProfileRef ref) async {
  // Watch auth state to ensure this provider refetches when user logs in/out
  final authStateAsync = ref.watch(authStateProvider);

  // Await the auth state to ensure we have a current user
  await authStateAsync.when(
    data: (authState) async {
      // Add a small delay to allow database trigger to complete
      await Future.delayed(const Duration(milliseconds: 100));
    },
    loading: () async {},
    error: (_, _) async {},
  );

  final authRepo = ref.watch(authRepositoryProvider);
  print('[currentProfile] Fetching profile after auth state change...');
  final profile = await authRepo.getCurrentProfile();
  print('[currentProfile] Profile fetched: ${profile?.id ?? 'null'}');
  return profile;
}
