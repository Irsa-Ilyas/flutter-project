import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomChipWidget - Yeh ek reusable chip widget hai jo:
/// - Filter tags display karne ke liye use hota hai
/// - Select/deselect functionality karta hai
/// - Custom styling support karta hai
/// - Icons support karta hai
///
/// Features:
/// - Selectable state
/// - Custom colors
/// - Icons support
/// - On-tap callback
class CustomChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.icon,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? selectedColor ?? AppColors.darkBlue
        : unselectedColor ?? AppColors.lightBlueBackground;
        
    final textColor = isSelected
        ? selectedTextColor ?? AppColors.onBackground
        : unselectedTextColor ?? AppColors.onBackground;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? selectedColor ?? AppColors.darkBlue
                : AppColors.lightBlue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: textColor,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}