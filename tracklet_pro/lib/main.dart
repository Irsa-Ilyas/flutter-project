import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/providers/app_providers.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:tracklet_pro/src/view/screens/splash/splash_screen.dart';

void main() {
  // Enable DevTools in debug mode
  if (kDebugMode) {
    // This helps with DevTools connectivity
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: child!,
          );
        },
      ),
    );
  }
}