import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomCardWidget - Yeh ek reusable card widget hai jo:
/// - Data display karne ke liye use hota hai
/// - Custom styling support karta hai
/// - Tap handling karta hai
/// - Shadow effects deta hai
///
/// Features:
/// - Custom elevation
/// - Rounded corners
/// - Tap callback
/// - Custom padding
class CustomCardWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;

  const CustomCardWidget({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.color,
    this.elevation,
    this.borderRadius,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      margin: margin ?? const EdgeInsets.all(8.0),
      color: color ?? AppColors.lightBlueBackground,
      elevation: elevation ?? 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12.0),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );

    // Agar width ya height specified ho to SizedBox mein wrap karo
    if (width != null || height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: card,
      );
    }

    return card;
  }
}