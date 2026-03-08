/// Domain model representing a shopping list item.
class ShoppingItem {
  final String id;
  final String householdId;
  final String title; // The meal/recipe name
  final bool isBought;
  final String?
  linkedPrepGroupId; // Links to the prep_group_id of the meal plan
  final DateTime createdAt;

  const ShoppingItem({
    required this.id,
    required this.householdId,
    required this.title,
    required this.isBought,
    this.linkedPrepGroupId,
    required this.createdAt,
  });

  /// Create a copy of ShoppingItem with optional field overrides.
  ShoppingItem copyWith({
    String? id,
    String? householdId,
    String? title,
    bool? isBought,
    String? linkedPrepGroupId,
    DateTime? createdAt,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      title: title ?? this.title,
      isBought: isBought ?? this.isBought,
      linkedPrepGroupId: linkedPrepGroupId ?? this.linkedPrepGroupId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShoppingItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;

  @override
  String toString() =>
      'ShoppingItem(id: $id, title: $title, isBought: $isBought)';
}
