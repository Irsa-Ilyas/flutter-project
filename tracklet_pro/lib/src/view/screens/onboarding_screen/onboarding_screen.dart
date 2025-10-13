import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/navigation/unified_main_screen.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String _imagePath = 'assets/images/Group.png';
  static const double _imageWidth = 234.07;
  static const double _imageHeight = 239.72;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 180),
                  SizedBox(
                    height: 200,
                    child: Image.asset(
                      _imagePath,
                      width: _imageWidth,
                      height: _imageHeight,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    AppStrings.trackAllYourOrders,
                    style: textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.easilyManageAndMonitor,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: CustomButtonWidget(
              type: ButtonType.full,
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const UnifiedMainScreen(),
                  ),
                );
              },
              text: AppStrings.getStarted,
            ),
          ),
        ],
      ),
    );
  }
}
