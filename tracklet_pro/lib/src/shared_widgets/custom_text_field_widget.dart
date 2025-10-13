import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomTextFieldWidget
/// - Reusable and clean text field widget
/// - Provider-friendly (Stateless)
/// - Supports error text, icons, and password fields
/// - Fully styled with proper borders and spacing
class CustomTextFieldWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final int? maxLines;
  final IconData? prefixIcon;
  final String? errorText;
  final bool enabled;
  final Widget? suffixIcon; // 👈 added for flexibility (e.g. password toggle or clear button)

  const CustomTextFieldWidget({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.prefixIcon,
    this.errorText,
    this.enabled = true,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // 👇 Clean border color logic
    final borderColor = errorText != null ? AppColors.error : AppColors.lightBlue;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          onChanged: onChanged,
          maxLines: obscureText ? 1 : maxLines, // 👈 safe condition
          enabled: enabled,
          textDirection: TextDirection.ltr,
          textAlign: TextAlign.left,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.disabledTextColor,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: AppColors.disabledTextColor,
                  )
                : null,
            suffixIcon: suffixIcon, // 👈 flexible suffix icon support
            errorText: errorText,
            errorStyle: TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
            filled: true,
            fillColor: AppColors.lightBlueBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color:
                    errorText != null ? AppColors.error : AppColors.darkBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
