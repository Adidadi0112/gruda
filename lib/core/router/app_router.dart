import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/household/presentation/screens/household_onboarding_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';

part 'app_router.g.dart';

/// Reactive GoRouter provider that watches auth state and profile changes
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // Watch auth state to trigger router rebuild on login/logout
  ref.watch(authStateProvider);

  // Watch profile to trigger router rebuild when household status changes
  // This ensures redirect logic runs when profile is invalidated after household creation
  ref.watch(currentProfileProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) async {
      print('\n========== [GoRouter Redirect] ==========');
      print('Route: ${state.matchedLocation}');

      final session = Supabase.instance.client.auth.currentSession;
      final isAuth = session != null;
      final isGoingToLogin = state.matchedLocation == '/login';

      print('Session exists: $isAuth');
      print(
        'Current user ID: ${Supabase.instance.client.auth.currentUser?.id}',
      );
      print('Going to login: $isGoingToLogin');

      if (!isAuth) {
        print('❌ NOT AUTHENTICATED - Redirecting to /login');
        return isGoingToLogin ? null : '/login';
      }

      // --- USER IS AUTHENTICATED ---
      print('✅ AUTHENTICATED - Checking household status...');

      if (isGoingToLogin) {
        try {
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          print('📋 Fetching profile for user: $currentUserId');
          // Fetch current profile to check household status
          final profile = await ref.read(currentProfileProvider.future);

          print('Profile result: $profile');
          print('Profile ID: ${profile?.id}');
          print('Display name: ${profile?.displayName}');
          print('Household ID: ${profile?.householdId}');

          // SECURITY CHECK: Ensure profile belongs to current user
          if (profile != null && profile.id != currentUserId) {
            print(
              '⚠️ SECURITY WARNING: Profile ID does not match current user ID!',
            );
            print('   Expected user: $currentUserId');
            print('   Got profile for: ${profile.id}');
            print('   This indicates cached data from a different user!');
            return null; // Don't redirect - something is wrong
          }

          if (profile == null) {
            print('⏳ Profile is still loading - returning null');
            return null; // Still loading
          }

          if (profile.householdId == null || profile.householdId!.isEmpty) {
            print('➡️ No household - Redirecting to /onboarding');
            return '/onboarding'; // Needs to join/create a household
          } else {
            print('✅ Household exists - Redirecting to /home');
            return '/home'; // All set, go to dashboard
          }
        } catch (e) {
          print('❌ Error fetching profile: $e');
          return null;
        }
      }

      print('No redirect needed');
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const HouseholdOnboardingScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    ],
  );
}
