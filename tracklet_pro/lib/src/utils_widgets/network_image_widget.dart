import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// NetworkImageWidget - Yeh ek reusable network image widget hai jo:
/// - Image loading handle karta hai
/// - Fallback image dikhata hai agar loading fail ho
/// - Loading state show karta hai
/// - Custom styling support karta hai
///
/// Features:
/// - Image loading with progress
/// - Fallback image
/// - Error handling
/// - Custom placeholder
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? fallbackImageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.fallbackImageUrl,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ??
              Container(
                width: width,
                height: height,
                color: AppColors.lightBlueBackground,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
                  ),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) {
          // Agar fallback image available ho to use karo
          if (fallbackImageUrl != null) {
            return ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Image.network(
                fallbackImageUrl!,
                width: width,
                height: height,
                fit: fit ?? BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Agar fallback image bhi fail ho jaye to error widget dikhao
                  return errorWidget ??
                      Container(
                        width: width,
                        height: height,
                        color: AppColors.lightBlueBackground,
                        child: const Icon(
                          Icons.broken_image,
                          color: AppColors.disabledTextColor,
                          size: 40,
                        ),
                      );
                },
              ),
            );
          }
          
          // Agar fallback image na ho to error widget dikhao
          // Following project specification for error handling
          return errorWidget ??
              Container(
                width: width,
                height: height,
                color: AppColors.lightBlueBackground,
                child: const Icon(
                  Icons.broken_image,
                  color: AppColors.disabledTextColor, // Following project spec: consistent styling using AppColors.disabledTextColor
                  size: 40,
                ),
              );
        },
      ),
    );
  }
}