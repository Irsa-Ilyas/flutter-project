import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// CustomImagePickerWidget - Yeh ek reusable image picker widget hai jo:
/// - Image upload functionality provide karta hai
/// - Image preview dikhata hai
/// - Loading state handle karta hai
/// - Error handling karta hai
///
/// Features:
/// - Image selection from gallery/camera
/// - Image preview
/// - Loading state
/// - Error handling
class CustomImagePickerWidget extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onPickImage;
  final VoidCallback? onRemoveImage;
  final bool isLoading;
  final String? errorText;

  const CustomImagePickerWidget({
    super.key,
    this.imagePath,
    this.onPickImage,
    this.onRemoveImage,
    this.isLoading = false,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Image',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: AppColors.lightBlueBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? AppColors.error
                  : AppColors.lightBlue,
              width: 1,
            ),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.darkBlue),
                  ),
                )
              : imagePath != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            imagePath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.lightBlueBackground,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColors.disabledTextColor,
                                  size: 40,
                                ),
                              );
                            },
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close,
                                color: AppColors.onBackground,
                                size: 16,
                              ),
                              onPressed: onRemoveImage,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 40,
                            color: AppColors.disabledTextColor,
                          ),
                          const SizedBox(height: 10),
                          CustomButtonWidget(
                            type: ButtonType.small,
                            text: 'Select Image',
                            icon: Icons.upload,
                            onPressed: onPickImage ?? () {},
                          ),
                        ],
                      ),
                    ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: const TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}