import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomLoaderWidget - Yeh ek reusable loader widget hai jo:
/// - Circular progress indicator display karta hai
/// - Custom size support karta hai
/// - Custom color support karta hai
/// - Background overlay support karta hai
///
/// Features:
/// - Different sizes (small, medium, large)
/// - Custom colors
/// - Overlay background
/// - Easy to use
class CustomLoaderWidget extends StatelessWidget {
  final LoaderSize size;
  final Color? color;
  final bool withBackground;

  const CustomLoaderWidget({
    super.key,
    this.size = LoaderSize.medium,
    this.color,
    this.withBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final loaderColor = color ?? AppColors.darkBlue; // Replaced primary with darkBlue
    final loaderSize = _getSize();

    if (withBackground) {
      return Container(
        color: AppColors.onBackground.withValues(alpha: 0.5), // Replaced black with onBackground
        child: Center(
          child: _buildLoader(loaderColor, loaderSize),
        ),
      );
    }

    return Center(
      child: _buildLoader(loaderColor, loaderSize),
    );
  }

  /// Loader ka size determine karne ke liye private method
  double _getSize() {
    switch (size) {
      case LoaderSize.small:
        return 20.0;
      case LoaderSize.medium:
        return 40.0;
      case LoaderSize.large:
        return 60.0;
    }
  }

  /// Actual loader widget banane ke liye private method
  Widget _buildLoader(Color color, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
        strokeWidth: _getStrokeWidth(),
      ),
    );
  }

  /// Stroke width determine karne ke liye private method
  double _getStrokeWidth() {
    switch (size) {
      case LoaderSize.small:
        return 2.0;
      case LoaderSize.medium:
        return 4.0;
      case LoaderSize.large:
        return 6.0;
    }
  }
}

/// Loader sizes define karne ke liye enum
enum LoaderSize {
  small,
  medium,
  large,
}