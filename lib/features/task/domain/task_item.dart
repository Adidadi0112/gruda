/// Domain model representing a one-time task.
class TaskItem {
  final String id;
  final String householdId;
  final String ownerId;
  final String title;
  final String? category;
  final DateTime dueDate;
  final bool isCompleted;
  final bool isHousehold;

  const TaskItem({
    required this.id,
    required this.householdId,
    required this.ownerId,
    required this.title,
    this.category,
    required this.dueDate,
    required this.isCompleted,
    required this.isHousehold,
  });

  /// Create a copy of TaskItem with optional field overrides.
  TaskItem copyWith({
    String? id,
    String? householdId,
    String? ownerId,
    String? title,
    String? category,
    DateTime? dueDate,
    bool? isCompleted,
    bool? isHousehold,
  }) {
    return TaskItem(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      isHousehold: isHousehold ?? this.isHousehold,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          householdId == other.householdId &&
          ownerId == other.ownerId &&
          title == other.title &&
          isHousehold == other.isHousehold &&
          category == other.category &&
          dueDate == other.dueDate &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      householdId.hashCode ^
      ownerId.hashCode ^
      title.hashCode ^
      category.hashCode ^
      dueDate.hashCode ^
      isCompleted.hashCode;

  @override
  String toString() =>
      'TaskItem(id: $id, title: $title, dueDate: $dueDate, isCompleted: $isCompleted)';
}
