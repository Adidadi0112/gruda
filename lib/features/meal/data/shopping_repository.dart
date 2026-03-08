import '../domain/shopping_item.dart';

/// Abstract interface for shopping list operations.
abstract class ShoppingRepository {
  /// Watch all shopping items for the current household.
  Stream<List<ShoppingItem>> watchShoppingItems();

  /// Add a shopping item (typically called automatically after meal prep save).
  Future<void> addShoppingItem({
    required String title,
    String? linkedPrepGroupId,
  });

  /// Bulk insert shopping items (called after meal prep save).
  Future<void> bulkAddShoppingItems(List<Map<String, dynamic>> items);

  /// Update a shopping item (e.g., toggle is_bought).
  Future<void> updateShoppingItem(ShoppingItem item);

  /// Delete a shopping item by ID.
  Future<void> deleteShoppingItem(String itemId);

  /// Delete all shopping items linked to a prep_group_id.
  Future<void> deleteShoppingItemsByPrepGroupId(String prepGroupId);
}
