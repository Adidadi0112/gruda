import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../domain/shopping_item.dart';
import 'shopping_repository.dart';

/// Concrete implementation of ShoppingRepository using Supabase.
class ShoppingRepositoryImpl implements ShoppingRepository {
  final supabase.SupabaseClient _supabase;
  final String Function() getHouseholdId;

  ShoppingRepositoryImpl(this._supabase, {required this.getHouseholdId});

  @override
  Stream<List<ShoppingItem>> watchShoppingItems() {
    final userId = _supabase.auth.currentUser?.id;
    final householdId = getHouseholdId();

    print(
      '[watchShoppingItems] Fetching shopping items, householdId: $householdId',
    );

    if (userId == null || householdId.isEmpty) {
      print(
        '[watchShoppingItems] ❌ Missing user ID or household ID - returning empty stream',
      );
      return Stream.value([]);
    }

    return _supabase
        .from('shopping_items')
        .stream(primaryKey: ['id'])
        .eq('household_id', householdId)
        .order('created_at')
        .map((data) {
          print(
            '[watchShoppingItems] Raw data received: ${data.length} records',
          );
          final items = (data as List<dynamic>)
              .map(
                (json) => _shoppingItemFromJson(json as Map<String, dynamic>),
              )
              .toList();
          print('[watchShoppingItems] ✅ Received ${items.length} items');
          return items;
        });
  }

  @override
  Future<void> addShoppingItem({
    required String title,
    String? linkedPrepGroupId,
  }) async {
    print('[addShoppingItem] Adding item: title=$title');
    try {
      final userId = _supabase.auth.currentUser?.id;
      final householdId = getHouseholdId();

      if (userId == null || householdId.isEmpty) {
        print(
          '[addShoppingItem] ❌ User not authenticated or not in a household',
        );
        throw Exception('User must be authenticated and in a household');
      }

      await _supabase.from('shopping_items').insert({
        'title': title,
        'household_id': householdId,
        'is_bought': false,
        'linked_prep_group_id': linkedPrepGroupId,
      });

      print('[addShoppingItem] ✅ Shopping item added successfully');
    } catch (e) {
      print('[addShoppingItem] ❌ Error adding shopping item: $e');
      rethrow;
    }
  }

  @override
  Future<void> bulkAddShoppingItems(List<Map<String, dynamic>> items) async {
    print('[bulkAddShoppingItems] Adding ${items.length} items');
    try {
      final userId = _supabase.auth.currentUser?.id;
      final householdId = getHouseholdId();

      if (userId == null || householdId.isEmpty) {
        print(
          '[bulkAddShoppingItems] ❌ User not authenticated or not in a household',
        );
        throw Exception('User must be authenticated and in a household');
      }

      // Enrich items with household_id and is_bought status
      final enrichedItems = items.map((item) {
        return {
          'title': item['title'],
          'household_id': householdId,
          'is_bought': false,
          'linked_prep_group_id': item['linkedPrepGroupId'],
        };
      }).toList();

      await _supabase.from('shopping_items').insert(enrichedItems);

      print(
        '[bulkAddShoppingItems] ✅ Added ${items.length} shopping items successfully',
      );
    } catch (e) {
      print('[bulkAddShoppingItems] ❌ Error bulk adding items: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateShoppingItem(ShoppingItem item) async {
    print('[updateShoppingItem] Updating item: ${item.id}');
    try {
      await _supabase
          .from('shopping_items')
          .update({'title': item.title, 'is_bought': item.isBought})
          .eq('id', item.id);

      print('[updateShoppingItem] ✅ Shopping item updated successfully');
    } catch (e) {
      print('[updateShoppingItem] ❌ Error updating shopping item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteShoppingItem(String itemId) async {
    print('[deleteShoppingItem] Deleting item: $itemId');
    try {
      await _supabase.from('shopping_items').delete().eq('id', itemId);

      print('[deleteShoppingItem] ✅ Shopping item deleted successfully');
    } catch (e) {
      print('[deleteShoppingItem] ❌ Error deleting shopping item: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteShoppingItemsByPrepGroupId(String prepGroupId) async {
    print(
      '[deleteShoppingItemsByPrepGroupId] Deleting items for prepGroupId: $prepGroupId',
    );
    try {
      final householdId = getHouseholdId();

      await _supabase
          .from('shopping_items')
          .delete()
          .eq('household_id', householdId)
          .eq('linked_prep_group_id', prepGroupId);

      print(
        '[deleteShoppingItemsByPrepGroupId] ✅ Deleted shopping items for prepGroupId: $prepGroupId',
      );
    } catch (e) {
      print(
        '[deleteShoppingItemsByPrepGroupId] ❌ Error deleting shopping items: $e',
      );
      rethrow;
    }
  }

  /// Helper to convert JSON from Supabase to ShoppingItem domain model.
  ShoppingItem _shoppingItemFromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      title: json['title'] as String,
      isBought: json['is_bought'] as bool? ?? false,
      linkedPrepGroupId: json['linked_prep_group_id'] as String?,
      createdAt: DateTime.parse(
        json['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}
