import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// AuthFooterWidget - Yeh ek reusable auth footer widget hai jo:
/// - Signup/login toggle text dikhata hai
/// - Navigation support karta hai
/// - Custom styling karta hai
///
/// Features:
/// - Toggle text
/// - Navigation callback
/// - Custom styling
class AuthFooterWidget extends StatelessWidget {
  final String text;
  final String actionText;
  final VoidCallback onActionPressed;

  const AuthFooterWidget({
    super.key,
    required this.text,
    required this.actionText,
    required this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.disabledTextColor, // Replaced gray600 with disabledTextColor
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onActionPressed,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue, // Replaced primary with darkBlue
            ),
          ),
        ),
      ],
    );
  }
}