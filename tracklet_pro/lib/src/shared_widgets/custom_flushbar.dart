import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/widget/custom_text.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class CustomFlushbar {
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.successColor, // Replaced success with successColor
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.error, // This is already correct
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.warningColor, // Replaced warning with warningColor
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showFlushbar(
      context: context,
      message: message,
      backgroundColor: AppColors.mediumBlue, // Replaced info with mediumBlue as a substitute
      duration: duration,
    );
  }

  static void _showFlushbar({
    required BuildContext context,
    required String message,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: BodyText(
          message,
          style: TextStyle(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}