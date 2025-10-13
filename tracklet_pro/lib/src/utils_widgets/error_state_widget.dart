import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';


class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? buttonText;
  final VoidCallback? onRetryPressed;

  const ErrorStateWidget({
    super.key,
    this.title = 'Something Went Wrong',
    this.message = 'An error occurred while loading the data. Please try again.',
    this.icon,
    this.buttonText = 'Retry',
    this.onRetryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.error,
              size: 80,
              color: AppColors.error,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.disabledTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onRetryPressed != null) ...[
              const SizedBox(height: 30),
              CustomButtonWidget(
                type: ButtonType.small,
                text: buttonText!,
                backgroundColor: AppColors.error,
                onPressed: onRetryPressed!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}