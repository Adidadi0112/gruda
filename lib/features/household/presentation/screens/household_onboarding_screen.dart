import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../auth/presentation/auth_provider.dart';
import '../household_provider.dart';

/// HouseholdOnboardingScreen - Setup household (create new or join existing).
class HouseholdOnboardingScreen extends ConsumerStatefulWidget {
  const HouseholdOnboardingScreen({super.key});

  @override
  ConsumerState<HouseholdOnboardingScreen> createState() =>
      _HouseholdOnboardingScreenState();
}

class _HouseholdOnboardingScreenState
    extends ConsumerState<HouseholdOnboardingScreen> {
  late final TextEditingController _householdNameController;
  late final TextEditingController _inviteCodeController;

  bool _isLoadingCreate = false;
  bool _isLoadingJoin = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _householdNameController = TextEditingController();
    _inviteCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _householdNameController.dispose();
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _createHousehold() async {
    final name = _householdNameController.text.trim();
    if (name.isEmpty) {
      _showError('Proszę wpisać nazwę gospodarstwa');
      return;
    }

    setState(() {
      _isLoadingCreate = true;
      _errorMessage = null;
    });

    try {
      print('[HouseholdOnboarding] Creating household: $name');
      await ref.read(createHouseholdProvider(name).future);

      // Invalidate profile provider so router re-checks and redirects to /home
      print(
        '[HouseholdOnboarding] \u2705 Household created - Invalidating currentProfileProvider to trigger router redirect',
      );
      ref.invalidate(currentProfileProvider);

      // Router will automatically redirect to /home when profile is updated
      if (mounted) {
        _householdNameController.clear();
      }
    } catch (e) {
      print('[HouseholdOnboarding] \u274c Error creating household: $e');
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCreate = false;
        });
      }
    }
  }

  Future<void> _joinHousehold() async {
    final code = _inviteCodeController.text.trim().toUpperCase();
    if (code.isEmpty) {
      _showError('Proszę wpisać kod zaproszenia');
      return;
    }

    if (code.length != 6) {
      _showError('Kod zaproszenia musi mieć 6 znaków');
      return;
    }

    setState(() {
      _isLoadingJoin = true;
      _errorMessage = null;
    });

    try {
      print('[HouseholdOnboarding] Joining household with code: $code');
      await ref.read(joinHouseholdProvider(code).future);

      // Invalidate profile provider so router re-checks and redirects to /home
      print(
        '[HouseholdOnboarding] \u2705 Household joined - Invalidating currentProfileProvider to trigger router redirect',
      );
      ref.invalidate(currentProfileProvider);

      // Router will automatically redirect to /home when profile is updated
      if (mounted) {
        _inviteCodeController.clear();
      }
    } catch (e) {
      print('[HouseholdOnboarding] \u274c Error joining household: $e');
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingJoin = false;
        });
      }
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text('Skonfiguruj swoje gospodarstwo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                'Zaczynajmy!',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Utwórz nowe gospodarstwo lub dołącz do istniejącego',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Error Banner
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.error,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              if (_errorMessage != null) const SizedBox(height: 24),

              // Create Household Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.home,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Utwórz nowe gospodarstwo',
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Zacznij nowe gospodarstwo i zaproś członków rodziny',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _householdNameController,
                        decoration: InputDecoration(
                          labelText: 'Nazwa gospodarstwa',
                          hintText: 'np. Rodzina Kowalskich',
                        ),
                        enabled: !_isLoadingCreate && !_isLoadingJoin,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_isLoadingCreate || _isLoadingJoin)
                              ? null
                              : _createHousehold,
                          child: _isLoadingCreate
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : const Text('Utwórz'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Join Household Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            LucideIcons.users,
                            color: theme.colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Dołącz do istniejącego gospodarstwa',
                              style: theme.textTheme.headlineSmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Dołącz do gospodarstwa rodziny za pomocą kodu zaproszenia',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _inviteCodeController,
                        decoration: InputDecoration(
                          labelText: 'Kod zaproszenia',
                          hintText: 'np. ABC123',
                          helperText: '6 znaków',
                        ),
                        maxLength: 6,
                        textCapitalization: TextCapitalization.characters,
                        enabled: !_isLoadingCreate && !_isLoadingJoin,
                        onChanged: (value) {
                          // Auto-uppercase as user types
                          if (value != value.toUpperCase()) {
                            _inviteCodeController.value = _inviteCodeController
                                .value
                                .copyWith(
                                  text: value.toUpperCase(),
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: value.length),
                                  ),
                                );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_isLoadingCreate || _isLoadingJoin)
                              ? null
                              : _joinHousehold,
                          child: _isLoadingJoin
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      theme.colorScheme.onPrimary,
                                    ),
                                  ),
                                )
                              : const Text('Dołącz'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
