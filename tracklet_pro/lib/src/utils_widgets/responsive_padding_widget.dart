import 'package:flutter/material.dart';

/// ResponsivePaddingWidget - Yeh ek reusable responsive padding widget hai jo:
/// - Auto adjust padding karta hai screen size ke according
/// - Different devices ke liye different padding provide karta hai
/// - Consistent UI maintain karta hai
///
/// Features:
/// - Responsive padding
/// - Device-specific adjustments
/// - Easy to use
class ResponsivePaddingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? horizontalPadding;
  final double? verticalPadding;

  const ResponsivePaddingWidget({
    super.key,
    required this.child,
    this.padding,
    this.horizontalPadding,
    this.verticalPadding,
  });

  @override
  Widget build(BuildContext context) {
    // Screen size get karo
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Screen size ke according padding calculate karo
    final EdgeInsets effectivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? _getHorizontalPadding(screenWidth),
          vertical: verticalPadding ?? 16.0,
        );

    return Padding(
      padding: effectivePadding,
      child: child,
    );
  }

  /// Screen size ke according horizontal padding calculate karne ke liye method
  double _getHorizontalPadding(double screenWidth) {
    if (screenWidth < 400) {
      // Small phones
      return 16.0;
    } else if (screenWidth < 600) {
      // Medium phones
      return 20.0;
    } else if (screenWidth < 900) {
      // Tablets
      return 32.0;
    } else {
      // Large screens
      return 40.0;
    }
  }
}