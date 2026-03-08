import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/shopping_cycle.dart';
import '../../domain/shopping_item.dart';
import '../meal_provider.dart';

/// ShoppingListScreen - Displays the paginated shopping list by meal prep cycles.
/// Users can navigate between 3-day prep cycles, toggle items as bought/not bought, and view progress.
/// Also allows manual addition of shopping items.
class ShoppingListScreen extends ConsumerStatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  ConsumerState<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends ConsumerState<ShoppingListScreen> {
  late TextEditingController _itemController;

  @override
  void initState() {
    super.initState();
    _itemController = TextEditingController();
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _showAddItemDialog(BuildContext context) {
    _itemController.clear();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dodaj produkt'),
          content: TextField(
            controller: _itemController,
            decoration: InputDecoration(
              labelText: 'Nazwa produktu',
              hintText: 'np. Mleko, Chleb, Pomidory',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _addManualItem(context),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj'),
            ),
            FilledButton(
              onPressed: () => _addManualItem(context),
              child: const Text('Dodaj'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addManualItem(BuildContext context) async {
    final itemTitle = _itemController.text.trim();
    if (itemTitle.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Podaj nazwę produktu')));
      return;
    }

    try {
      // Get the current selected cycle
      final cycles = ref.read(shoppingCyclesProviderProvider).valueOrNull ?? [];
      final selectedIndex = ref.read(selectedCycleIndexProvider);
      final validIndex = selectedIndex.clamp(0, cycles.length - 1);
      final currentCycle = cycles[validIndex];

      await ref.read(
        addShoppingItemProvider(
          title: itemTitle,
          linkedPrepGroupId: currentCycle.prepGroupId,
        ).future,
      );
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produkt dodany do listy')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Błąd: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cyclesAsync = ref.watch(shoppingCyclesProviderProvider);
    final selectedIndex = ref.watch(selectedCycleIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista Zakupów'),
        centerTitle: true,
        elevation: 0,
      ),
      body: cyclesAsync.when(
        data: (cycles) {
          if (cycles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LucideIcons.listTodo,
                    size: 48,
                    color: theme.colorScheme.secondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Brak zaplanowanych zakupów',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Zaplanuj Meal Prep, aby wygenerować listę',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            );
          }

          // Clamp the selected index to valid range
          final validIndex = selectedIndex.clamp(0, cycles.length - 1);
          final currentCycle = cycles[validIndex];

          return Column(
            children: [
              // Cycle selector header
              _buildCycleSelectorHeader(
                currentCycle,
                cycles.length,
                validIndex,
                theme,
                ref,
              ),
              // Progress bar
              _buildProgressBar(currentCycle, theme),
              // Shopping items list
              Expanded(child: _buildItemsList(currentCycle, theme, ref)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Błąd: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddItemDialog(context),
        tooltip: 'Dodaj produkt',
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Widget _buildCycleSelectorHeader(
    ShoppingCycle cycle,
    int totalCycles,
    int currentIndex,
    ThemeData theme,
    WidgetRef ref,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        children: [
          // Left arrow button
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(LucideIcons.chevronLeft),
              onPressed: currentIndex > 0
                  ? () =>
                        ref.read(selectedCycleIndexProvider.notifier).previous()
                  : null,
              tooltip: 'Poprzedni cykl',
            ),
          ),
          // Center: Date range and cycle title
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cycle.displayTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  cycle.dateRangeDisplay,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Right arrow button
          SizedBox(
            width: 48,
            height: 48,
            child: IconButton(
              icon: const Icon(LucideIcons.chevronRight),
              onPressed: currentIndex < totalCycles - 1
                  ? () => ref.read(selectedCycleIndexProvider.notifier).next()
                  : null,
              tooltip: 'Następny cykl',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ShoppingCycle cycle, ThemeData theme) {
    final totalCount = cycle.totalCount;
    final unboughtCount = cycle.unboughtCount;
    final boughtCount = totalCount - unboughtCount;
    final progress = totalCount > 0 ? boughtCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Postęp',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$boughtCount/$totalCount kupione',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(ShoppingCycle cycle, ThemeData theme, WidgetRef ref) {
    final items = cycle.items;

    if (items.isEmpty) {
      return Center(
        child: Text(
          'Brak produktów w tym cyklu',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
      );
    }

    // Separate bought and unbought items
    final unbought = items.where((item) => !item.isBought).toList();
    final bought = items.where((item) => item.isBought).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Unbought items section
        if (unbought.isNotEmpty) ...[
          Text(
            'Do kupienia (${unbought.length})',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          ...unbought.asMap().entries.map((entry) {
            final item = entry.value;
            return _buildShoppingItemTile(item, theme, ref);
          }),
          const SizedBox(height: 24),
        ],
        // Bought items section
        if (bought.isNotEmpty) ...[
          Text(
            'Kupione (${bought.length})',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          ...bought.asMap().entries.map((entry) {
            final item = entry.value;
            return _buildShoppingItemTile(item, theme, ref);
          }),
        ],
      ],
    );
  }

  Widget _buildShoppingItemTile(
    ShoppingItem item,
    ThemeData theme,
    WidgetRef ref,
  ) {
    final title = item.title;
    final isBought = item.isBought;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          leading: Checkbox(
            value: isBought,
            onChanged: (_) async {
              await ref.read(
                updateShoppingItemProvider(
                  item.copyWith(isBought: !isBought),
                ).future,
              );
              // Invalidate shopping cycles to refresh the UI
              ref.invalidate(shoppingCyclesProviderProvider);
            },
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isBought
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.onSurface,
              decoration: isBought ? TextDecoration.lineThrough : null,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(LucideIcons.trash2, size: 18),
            onPressed: () {
              ref.read(deleteShoppingItemProvider(item.id).future);
              // Invalidate shopping cycles to refresh the UI
              ref.invalidate(shoppingCyclesProviderProvider);
            },
            tooltip: 'Usuń',
          ),
        ),
      ),
    );
  }
}
