import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/view/screens/auth/login_screen.dart';
import 'package:tracklet_pro/src/navigation/unified_main_screen.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/view_model/language_view_model.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class LanguageSelectorScreen extends StatelessWidget {
  const LanguageSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 64),
            Center(
              child: Text(
                AppStrings.chooseYourLanguage,
                style:
                    Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.w500,
                    ) ??
                    TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onBackground,
                    ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                AppStrings.selectYourPreferredLanguage,
                style:
                    Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.onBackground,
                    ) ??
                    TextStyle(fontSize: 16, color: AppColors.onBackground),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LanguageCircle(
                  label: 'Eng',
                  onTap: () => Provider.of<LanguageViewModel>(
                    context,
                    listen: false,
                  ).selectLanguage('en'),
                  isSelected:
                      Provider.of<LanguageViewModel>(
                        context,
                      ).selectedLanguage ==
                      'en',
                ),
                const SizedBox(width: 24),
                _LanguageCircle(
                  label: 'اردو',
                  onTap: () => Provider.of<LanguageViewModel>(
                    context,
                    listen: false,
                  ).selectLanguage('ur'),
                  isSelected:
                      Provider.of<LanguageViewModel>(
                        context,
                      ).selectedLanguage ==
                      'ur',
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: CustomButtonWidget(
                  type: ButtonType.full,
                  onPressed:
                      Provider.of<LanguageViewModel>(
                        context,
                      ).selectedLanguage.isNotEmpty
                      ? () => _navigateToNextScreen(context)
                      : () {},
                  text: AppStrings.continueText,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (authProvider.isLoggedIn) {
      if (authProvider.isGasPlantUser() || authProvider.isDistributorUser()) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UnifiedMainScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}

class _LanguageCircle extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  const _LanguageCircle({
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: isSelected
              ? 104
              : 96, // 52 * 2 for selected, 48 * 2 for normal
          height: isSelected ? 104 : 96,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors
                      .darkBlue // Using AppColors with opacity
                : AppColors.disabledTextColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.darkBlue
                  : AppColors.lightBlueBackground,
              width: isSelected ? 3 : 2,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style:
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: isSelected
                        ? AppColors.onBackground
                        : AppColors.lightBlueBackground,
                    fontSize: isSelected ? 24 : 22,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ) ??
                  TextStyle(
                    color: isSelected
                        ? AppColors.onBackground
                        : AppColors.lightBlueBackground,
                    fontSize: isSelected ? 24 : 22,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
