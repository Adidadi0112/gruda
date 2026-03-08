import '../domain/household.dart';

/// Abstract interface for household operations.
abstract class HouseholdRepository {
  /// Creates a new household with the given name.
  /// Generates a random 6-character invite code and updates the user's profile.
  Future<Household> createHousehold(String name);

  /// Joins an existing household using the given invite code.
  /// Updates the current user's profile with the household ID.
  Future<Household> joinHousehold(String inviteCode);
}
