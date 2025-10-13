import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomChipWidget - Yeh ek reusable chip widget hai jo:
/// - Custom styling ke sath kaam karta hai
/// - Consistent appearance provide karta hai poore app me
/// - Flexible text and background colors ke sath
///
/// Features:
/// - Rounded rectangular shape with custom border radius
/// - Configurable padding
/// - Custom background and text colors
/// - Small font size for compact display
class CustomChipWidget extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? labelColor;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;

  const CustomChipWidget({
    super.key,
    required this.label,
    this.backgroundColor,
    this.labelColor,
    this.padding,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(39),
      ),
      padding: padding ?? const EdgeInsets.only(top: 0, left: 4, right: 4, bottom: 0),
      label: Text(
        label,
        style: TextStyle(
          color: labelColor ?? AppColors.lightBlueBackground,
          fontSize: fontSize ?? 10,
        ),
      ),
      backgroundColor: backgroundColor ?? AppColors.onBackground,
    );
  }
}