import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth_provider.dart';

/// LoginScreen - A simple, elegant form for Sign In and Sign Up.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _displayNameController;

  bool _isSignUp = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _displayNameController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleAuth() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);

      if (_isSignUp) {
        // Validate display name
        if (_displayNameController.text.trim().isEmpty) {
          setState(() {
            _errorMessage = 'Display name is required';
            _isLoading = false;
          });
          return;
        }

        await authRepo.signUp(
          _emailController.text.trim(),
          _passwordController.text,
          _displayNameController.text.trim(),
        );
      } else {
        await authRepo.signIn(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      // Auth state change will trigger router redirect automatically
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();
        _displayNameController.clear();
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                _isSignUp ? 'Create Account' : 'Welcome Back',
                style: theme.textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isSignUp
                    ? 'Set up your account to manage your household'
                    : 'Sign in to your account',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Email Field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@example.com',
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),

              // Display Name Field (only for Sign Up)
              if (_isSignUp) ...[
                TextFormField(
                  controller: _displayNameController,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    hintText: 'Your name',
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),
              ],

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: '••••••••',
                ),
                obscureText: true,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),

              // Error Message
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
              if (_errorMessage != null) const SizedBox(height: 16),

              // Auth Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleAuth,
                child: _isLoading
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
                    : Text(_isSignUp ? 'Create Account' : 'Sign In'),
              ),
              const SizedBox(height: 16),

              // Toggle Sign In / Sign Up
              Center(
                child: TextButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                            _errorMessage = null;
                          });
                        },
                  child: Text(
                    _isSignUp
                        ? 'Already have an account? Sign In'
                        : 'Don\'t have an account? Sign Up',
                    style: theme.textTheme.labelLarge,
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
