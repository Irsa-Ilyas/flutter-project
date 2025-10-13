import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomDropdownWidget - Yeh ek reusable dropdown widget hai jo:
/// - Gender, course, etc. options display karne ke liye use hota hai
/// - Custom styling support karta hai
/// - Validation support karta hai
/// - Hint text support karta hai
///
/// Features:
/// - Custom dropdown items
/// - Hint text
/// - Validation
/// - Custom styling
class CustomDropdownWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? value;
  final List<String> items;
  final void Function(String?)? onChanged;
  final String? errorText;
  final IconData? icon;

  const CustomDropdownWidget({
    super.key,
    this.label,
    this.hint,
    this.value,
    required this.items,
    this.onChanged,
    this.errorText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.onBackground,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<String>(
          initialValue: value,
          hint: hint != null
              ? Text(
                  hint!,
                  style: TextStyle(
                    color: AppColors.disabledTextColor,
                  ),
                )
              : null,
          items: items.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.onBackground,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: AppColors.disabledTextColor,
                  )
                : null,
            errorText: errorText,
            errorStyle: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
            filled: true,
            fillColor: AppColors.lightBlueBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null
                    ? AppColors.error
                    : AppColors.lightBlue,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null
                    ? AppColors.error
                    : AppColors.lightBlue,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: errorText != null
                    ? AppColors.error
                    : AppColors.darkBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.error,
                width: 2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
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