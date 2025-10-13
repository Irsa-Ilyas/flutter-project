import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';

class LogoutProvider extends ChangeNotifier {
  bool _isLoggingOut = false;
  String? _errorMessage;

  bool get isLoggingOut => _isLoggingOut;
  String? get errorMessage => _errorMessage;

  /// Perform logout operation
  Future<bool> logout(BuildContext context) async {
    _isLoggingOut = true;
    _errorMessage = null;

    // Check if context is still mounted before notifying
    if (!context.mounted) return false;

    notifyListeners();

    try {
      // Get the auth provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Call logout on auth provider
      await authProvider.logout();

      _isLoggingOut = false;

      // Check if context is still mounted before notifying
      if (context.mounted) {
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = 'Logout failed: ${e.toString()}';
      _isLoggingOut = false;

      // Check if context is still mounted before notifying
      if (context.mounted) {
        notifyListeners();

        // Show error message
        CustomFlushbar.showError(
          context,
          message: _errorMessage!,
        );
      }

      return false;
    }
  }

  /// Navigate to login screen after successful logout
  void navigateToLogin(BuildContext context) {
    // Navigate to login screen and remove all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  /// Complete logout process (logout + navigation)
  Future<void> performLogout(BuildContext context) async {
    final success = await logout(context);

    // Check if context is still mounted before proceeding with navigation
    if (!context.mounted) return;

    if (success) {
      // Show success message
      CustomFlushbar.showSuccess(
        context,
        message: 'Successfully logged out',
      );

      // Navigate to login screen
      navigateToLogin(context);
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _isLoggingOut = false;
    _errorMessage = null;
    super.dispose();
  }
}