import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// LanguagePreviewWidget - Yeh ek preview widget hai jo LanguageSelectorScreen jaisa UI dikhata hai
/// Features:
/// - Language options preview
/// - Selection indicator
/// - Consistent styling
class LanguagePreviewWidget extends StatelessWidget {
  final String selectedLanguage;
  final double width;
  final double height;

  const LanguagePreviewWidget({
    super.key,
    this.selectedLanguage = 'en',
    this.width = 300,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.splashBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.onBackground.withValues(alpha: 0.3), // Replaced white with onBackground
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.onBackground.withValues(alpha: 0.2), // Replaced black with onBackground
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Header section
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.onBackground.withValues(alpha: 0.2), // Replaced white with onBackground
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.onBackground.withValues(alpha: 0.3), // Replaced white with onBackground
                width: 2,
              ),
            ),
            child: Icon(
              Icons.language_outlined,
              size: 30,
              color: AppColors.onBackground, // Replaced white with onBackground
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'زبان منتخب کریں',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onBackground, // Replaced white with onBackground
            ),
          ),
          const SizedBox(height: 20),
          
          // Language options preview
          _buildLanguageOptionPreview('en', 'English', '🇺🇸', selectedLanguage == 'en'),
          const SizedBox(height: 12),
          _buildLanguageOptionPreview('ur', 'اردو', '🇵🇰', selectedLanguage == 'ur'),
          const SizedBox(height: 12),
          _buildLanguageOptionPreview('es', 'Español', '🇪🇸', selectedLanguage == 'es'),
        ],
      ),
    );
  }

  Widget _buildLanguageOptionPreview(
    String languageCode,
    String languageName,
    String countryFlag,
    bool isSelected,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected 
            ? AppColors.onBackground 
            : AppColors.onBackground.withValues(alpha: 0.9), // Replaced white with onBackground
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected 
              ? AppColors.darkBlue 
              : AppColors.onBackground.withValues(alpha: 0.5), // Replaced brandPrimary with darkBlue and white with onBackground
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Flag preview
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground, // Replaced gray100 with lightBlueBackground
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.lightBlue, // Replaced gray300 with lightBlue
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                countryFlag,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // Language name
          Expanded(
            child: Text(
              languageName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.darkBlue : AppColors.onBackground, // Replaced brandPrimary with darkBlue
              ),
            ),
          ),
          
          // Selection indicator
          if (isSelected)
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.darkBlue,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.check,
                  color: AppColors.onBackground, // Replaced white with onBackground
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}