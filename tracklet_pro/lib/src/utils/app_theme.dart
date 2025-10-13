import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkBlue, // Replaced brandPrimary with darkBlue
      brightness: Brightness.light,
    ),
    textTheme: _buildTextTheme(),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.onBackground, // Replaced onPrimary with onBackground
        backgroundColor: AppColors.darkBlue, // Replaced brandPrimary with darkBlue
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide( // Removed const
          color: AppColors.darkBlue, // Replaced brandPrimary with darkBlue
          width: 2,
        ),
      ),
    ),
  );

  static TextTheme _buildTextTheme() {
    return const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.darkBlue, // Replaced brandPrimary with darkBlue
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.onBackground,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.onBackground,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.disabledTextColor, // Replaced gray600 with disabledTextColor
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.onBackground,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.disabledTextColor, // Replaced gray600 with disabledTextColor
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: AppColors.disabledTextColor, // Replaced gray400 with disabledTextColor
      ),
    );
  }
}