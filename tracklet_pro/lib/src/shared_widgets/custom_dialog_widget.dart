import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomDialogWidget - Yeh ek reusable dialog widget hai jo:
/// - Confirmation dialogs display karta hai
/// - Alert dialogs display karta hai
/// - Custom buttons support karta hai
/// - Loading state support karta hai
///
/// Features:
/// - Positive/Negative buttons
/// - Loading state
/// - Custom styling
/// - Easy to use static methods
class CustomDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final String? positiveButtonText;
  final String? negativeButtonText;
  final VoidCallback? onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;
  final bool isDismissible;
  final bool isLoading;

  const CustomDialogWidget({
    super.key,
    required this.title,
    required this.message,
    this.positiveButtonText,
    this.negativeButtonText,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    this.isDismissible = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onBackground,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (negativeButtonText != null) ...[
                    CustomButtonWidget(
                      type: ButtonType.tab,
                      text: negativeButtonText!,
                      backgroundColor: AppColors.lightBlue,
                      textColor: AppColors.onBackground,
                      onPressed: onNegativeButtonPressed ??
                          () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                  ],
                  if (positiveButtonText != null)
                    CustomButtonWidget(
                      type: ButtonType.small,
                      text: positiveButtonText!,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? () {}
                          : (onPositiveButtonPressed ??
                              () => Navigator.of(context).pop()),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Static method confirmation dialog dikhane ke liye
  static Future<void> showConfirmation(
    BuildContext context, {
    required String title,
    required String message,
    String positiveButtonText = 'Confirm',
    String negativeButtonText = 'Cancel',
    VoidCallback? onPositiveButtonPressed,
    VoidCallback? onNegativeButtonPressed,
    bool isDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          title: title,
          message: message,
          positiveButtonText: positiveButtonText,
          negativeButtonText: negativeButtonText,
          onPositiveButtonPressed: onPositiveButtonPressed,
          onNegativeButtonPressed: onNegativeButtonPressed,
          isDismissible: isDismissible,
        );
      },
    );
  }

  /// Static method alert dialog dikhane ke liye
  static Future<void> showAlert(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onButtonPressed,
    bool isDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext context) {
        return CustomDialogWidget(
          title: title,
          message: message,
          positiveButtonText: buttonText,
          onPositiveButtonPressed: onButtonPressed,
          isDismissible: isDismissible,
        );
      },
    );
  }
}