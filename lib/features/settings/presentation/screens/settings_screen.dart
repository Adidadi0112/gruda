import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../../auth/data/auth_repository_impl.dart';

/// SettingsScreen - Placeholder for app settings and user profile.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ustawienia'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Section
                Card(
                  child: ListTile(
                    leading: const Icon(LucideIcons.user),
                    title: const Text('Profil'),
                    subtitle: const Text('Zarządzaj swoim profilem'),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () {
                      // TODO: Navigate to profile screen
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Household Section
                Card(
                  child: ListTile(
                    leading: const Icon(LucideIcons.home),
                    title: const Text('Gospodarstwo'),
                    subtitle: const Text('Zarządzaj członkami gospodarstwa'),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () {
                      // TODO: Navigate to household management
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // About Section
                Card(
                  child: ListTile(
                    leading: const Icon(LucideIcons.info),
                    title: const Text('O aplikacji'),
                    subtitle: const Text('Wersja 1.0.0'),
                    trailing: const Icon(LucideIcons.chevronRight),
                    onTap: () {
                      // TODO: Show about dialog
                    },
                  ),
                ),
              ],
            ),
          ),
          // Sign Out Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              icon: const Icon(LucideIcons.logOut),
              label: const Text('Wyloguj się'),
              onPressed: () => _handleSignOut(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wylogować się?'),
        content: const Text('Na pewno chcesz się wylogować?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Wyloguj'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      final supabase = ref.read(supabaseProvider);
      final authRepo = AuthRepositoryImpl(supabase);
      await authRepo.signOut();

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Wylogowano pomyślnie')));
      }
      // Router will automatically redirect to /login when auth state changes
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('❌ Błąd: $e')));
      }
    }
  }
}
