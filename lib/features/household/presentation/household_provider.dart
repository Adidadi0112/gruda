import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers/supabase_provider.dart';
import '../data/household_repository.dart';
import '../data/household_repository_impl.dart';
import '../domain/household.dart';

part 'household_provider.g.dart';

/// Provider for the HouseholdRepository instance.
final householdRepositoryProvider = Provider<HouseholdRepository>((ref) {
  final supabase = ref.watch(supabaseProvider);
  return HouseholdRepositoryImpl(supabase);
});

/// FutureProvider for creating a new household.
/// Usage: ref.read(createHouseholdProvider('My Household').future);
@riverpod
Future<Household> createHousehold(
  CreateHouseholdRef ref,
  String householdName,
) async {
  print(
    '[householdProvider.createHousehold] Provider called with: $householdName',
  );
  final householdRepo = ref.watch(householdRepositoryProvider);
  try {
    final household = await householdRepo.createHousehold(householdName);
    print(
      '[householdProvider.createHousehold] ✅ Provider returned: ${household.id}',
    );
    return household;
  } catch (e) {
    print('[householdProvider.createHousehold] ❌ Error: $e');
    rethrow;
  }
}

/// FutureProvider for joining an existing household.
/// Usage: ref.read(joinHouseholdProvider('ABC123').future);
@riverpod
Future<Household> joinHousehold(JoinHouseholdRef ref, String inviteCode) async {
  print(
    '[householdProvider.joinHousehold] Provider called with code: $inviteCode',
  );
  final householdRepo = ref.watch(householdRepositoryProvider);
  try {
    final household = await householdRepo.joinHousehold(inviteCode);
    print(
      '[householdProvider.joinHousehold] ✅ Provider returned: ${household.id}',
    );
    return household;
  } catch (e) {
    print('[householdProvider.joinHousehold] ❌ Error: $e');
    rethrow;
  }
}
