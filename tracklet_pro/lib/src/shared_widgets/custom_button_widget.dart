import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonType type;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;

  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = ButtonType.full,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure consistent use of primary color as per project specification
    final buttonColor = backgroundColor ?? AppColors.darkBlue; // Replaced primary with darkBlue
    final buttonTextColor = textColor ?? AppColors.lightBlueBackground; // Replaced onPrimary with onBackground

    switch (type) {
      case ButtonType.small:
        return _buildSmallButton(buttonColor, buttonTextColor);
      case ButtonType.full:
        return _buildFullButton(buttonColor, buttonTextColor);
      case ButtonType.tab:
        return _buildTabButton(buttonColor, buttonTextColor);
    }
  }

  // Chhota button banane ke liye method
  Widget _buildSmallButton(Color buttonColor, Color buttonTextColor) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: AppColors.onBackground, // Replaced black with onBackground
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: buttonTextColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: buttonTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // Poora width ka button banane ke liye method
  Widget _buildFullButton(Color buttonColor, Color buttonTextColor) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                    strokeWidth: 3,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: buttonTextColor),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      text,
                      style: TextStyle(
                        color: buttonTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // Tab button banane ke liye method
  Widget _buildTabButton(Color buttonColor, Color buttonTextColor) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: buttonColor, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(buttonTextColor),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: buttonTextColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: buttonTextColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Button types define karne ke liye enum
enum ButtonType {
  small, // Chhota button
  full,  // Poora width ka button
  tab,   // Tab ke liye button
}