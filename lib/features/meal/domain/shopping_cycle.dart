import 'shopping_item.dart';

/// Represents a 3-day meal prep cycle with associated shopping items.
class ShoppingCycle {
  final String? prepGroupId; // null for manually added items
  final DateTime startDate;
  final DateTime endDate;
  final String? mealPrepSetName; // Optional name for the prep set
  final List<ShoppingItem> items;

  const ShoppingCycle({
    required this.prepGroupId,
    required this.startDate,
    required this.endDate,
    this.mealPrepSetName,
    required this.items,
  });

  /// Returns the date range formatted as "DD.MM - DD.MM"
  String get dateRangeDisplay {
    final startStr =
        '${startDate.day.toString().padLeft(2, '0')}.${startDate.month.toString().padLeft(2, '0')}';
    final endStr =
        '${endDate.day.toString().padLeft(2, '0')}.${endDate.month.toString().padLeft(2, '0')}';
    return '$startStr - $endStr';
  }

  /// Returns the number of unbought items
  int get unboughtCount => items.where((item) => !item.isBought).length;

  /// Returns the total number of items
  int get totalCount => items.length;

  /// Returns a display title for the cycle
  String get displayTitle {
    if (mealPrepSetName != null && mealPrepSetName!.isNotEmpty) {
      return mealPrepSetName!;
    }
    return dateRangeDisplay;
  }

  @override
  String toString() =>
      'ShoppingCycle(prepGroupId: $prepGroupId, startDate: $startDate, endDate: $endDate, items: ${items.length})';
}
