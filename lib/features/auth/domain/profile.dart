/// Profile domain model representing a user profile.
class Profile {
  final String id;
  final String displayName;
  final String? householdId;

  const Profile({
    required this.id,
    required this.displayName,
    this.householdId,
  });

  /// Create a copy of Profile with optional field overrides.
  Profile copyWith({String? id, String? displayName, String? householdId}) {
    return Profile(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      householdId: householdId ?? this.householdId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          householdId == other.householdId;

  @override
  int get hashCode => id.hashCode ^ displayName.hashCode ^ householdId.hashCode;

  @override
  String toString() =>
      'Profile(id: $id, displayName: $displayName, householdId: $householdId)';
}
