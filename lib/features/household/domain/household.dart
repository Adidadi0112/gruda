/// Household domain model representing a household/home.
class Household {
  final String id;
  final String name;
  final String inviteCode;
  final DateTime createdAt;

  const Household({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.createdAt,
  });

  /// Create a copy of Household with optional field overrides.
  Household copyWith({
    String? id,
    String? name,
    String? inviteCode,
    DateTime? createdAt,
  }) {
    return Household(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Household &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          inviteCode == other.inviteCode &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ inviteCode.hashCode ^ createdAt.hashCode;

  @override
  String toString() =>
      'Household(id: $id, name: $name, inviteCode: $inviteCode, createdAt: $createdAt)';
}
