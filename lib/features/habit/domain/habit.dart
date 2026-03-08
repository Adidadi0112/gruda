/// Habit domain model representing a single habit.
class Habit {
  final String id;
  final String userId;
  final String? householdId;
  final String title;
  final String? description;
  final String? category;
  final String? iconName; // Icon key from IconMapping
  final bool isHousehold;
  final DateTime createdAt;
  final DateTime? completedAt; // Last completion date

  const Habit({
    required this.id,
    required this.userId,
    this.householdId,
    required this.title,
    this.description,
    this.category,
    this.iconName,
    required this.isHousehold,
    required this.createdAt,
    this.completedAt,
  });

  /// Create a copy of Habit with optional field overrides.
  Habit copyWith({
    String? id,
    String? userId,
    String? householdId,
    String? title,
    String? description,
    String? category,
    String? iconName,
    bool? isHousehold,
    DateTime? createdAt,
    DateTime? completedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      householdId: householdId ?? this.householdId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      iconName: iconName ?? this.iconName,
      isHousehold: isHousehold ?? this.isHousehold,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          householdId == other.householdId &&
          title == other.title &&
          description == other.description &&
          category == other.category &&
          iconName == other.iconName &&
          isHousehold == other.isHousehold &&
          createdAt == other.createdAt &&
          completedAt == other.completedAt;

  @override
  int get hashCode =>
      id.hashCode ^
      userId.hashCode ^
      householdId.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode ^
      iconName.hashCode ^
      isHousehold.hashCode ^
      createdAt.hashCode ^
      completedAt.hashCode;

  @override
  String toString() =>
      'Habit(id: $id, userId: $userId, householdId: $householdId, title: $title, category: $category, iconName: $iconName, isHousehold: $isHousehold, createdAt: $createdAt, completedAt: $completedAt)';
}
