import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_strings.dart';

/// AuthHeaderWidget - Yeh ek reusable auth header widget hai jo:
/// - Logo display karta hai
/// - Welcome text dikhata hai
/// - Custom styling support karta hai
///
/// Features:
/// - App logo
/// - Welcome message
/// - Custom styling
class AuthHeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeaderWidget({
    super.key,
    this.title = AppStrings.appName,
    this.subtitle = 'Welcome back! Please sign in to continue',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.lock,
          size: 80,
          color: AppColors.darkBlue, // Replaced primary with darkBlue
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.disabledTextColor, // Replaced gray600 with disabledTextColor
          ),
        ),
      ],
    );
  }
}