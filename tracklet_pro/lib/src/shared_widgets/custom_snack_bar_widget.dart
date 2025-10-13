import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomSnackBarWidget - Yeh ek reusable snack bar widget hai jo:
/// - Success messages display karta hai
/// - Error messages display karta hai
/// - Custom styling karta hai
/// - Animation support karta hai
///
/// Features:
/// - Different colors for success/error
/// - Custom duration
/// - Easy to use static methods
class CustomSnackBarWidget {
  /// Success message dikhane ke liye static method
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.successColor, // Replaced success with successColor
      duration: duration,
    );
  }

  /// Error message dikhane ke liye static method
  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.error, // This is already correct
      duration: duration,
    );
  }

  /// Warning message dikhane ke liye static method
  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.warningColor, // Replaced warning with warningColor
      duration: duration,
    );
  }

  /// Info message dikhane ke liye static method
  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackBar(
      context: context,
      message: message,
      backgroundColor: AppColors.mediumBlue, // Replaced info with mediumBlue as a substitute
      duration: duration,
    );
  }

  /// Actual snack bar dikhane ke liye private method
  static void _showSnackBar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}