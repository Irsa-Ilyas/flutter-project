import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view/screens/language/language_selector_screen.dart';
import 'package:tracklet_pro/src/widget/index.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/utils_widgets/network_image_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to the appropriate screen after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen(context);
    });

    return Scaffold(
      backgroundColor: AppColors.darkBlue, // Using darkBlue for splash background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Using NetworkImageWidget for the logo
            NetworkImageWidget(
              imageUrl: 'https://cdn-icons-png.flaticon.com/512/888/888846.png', // Example logo URL
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorWidget: const Icon(
                Icons.local_gas_station,
                size: 100,
                color: AppColors.lightBlueBackground, // Changed to match project spec colors
              ),
            ),
            const SizedBox(height: 30),
            HeadingText(
              AppStrings.splashTitle,
              style: const TextStyle(
                color: AppColors.lightBlueBackground, // Changed to match project spec colors
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            BodyText(
              AppStrings.splashSubtitle,
              style: const TextStyle(
                color: AppColors.lightBlueBackground, // Changed to match project spec colors
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.lightBlueBackground),
            ),
          ],
        ),
      ),
    );
  }

  _navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    
    if (!context.mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSelectorScreen(),
      ),
    );
  }
}