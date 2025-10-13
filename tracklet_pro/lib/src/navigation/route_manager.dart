import 'package:flutter/material.dart';

/// RouteManager - Yeh class centralized route navigation ke liye hai:
/// - Saare routes ek jagah define kiye hain
/// - Easy navigation ke liye helper methods provide karta hai
/// - Route names constants ke roop mein define kiye hain
///
/// Features:
/// - Named routes
/// - Route generation
/// - Navigation helpers
class RouteManager {
  // Route names constants
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';

  // Routes map - yeh app ke saare routes ko define karta hai
  static Map<String, WidgetBuilder> get routes {
    return {
      splash: (context) => const SplashScreen(), // Replace with actual screen
      login: (context) => const LoginScreen(),   // Replace with actual screen
      home: (context) => const HomeScreen(),     // Replace with actual screen
      profile: (context) => const ProfileScreen(), // Replace with actual screen
      settings: (context) => const SettingsScreen(), // Replace with actual screen
    };
  }

  // Generate route - agar koi route match na ho to yeh method call hota hai
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteManager.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteManager.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RouteManager.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case RouteManager.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  // Navigation helper methods - yeh methods navigation ko asaan banate hain
  static void push(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  static void pushReplacement(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  static void pushAndRemoveUntil(BuildContext context, String routeName) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
  }

  static void pop(BuildContext context) {
    Navigator.pop(context);
  }

  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}

// Dummy screens - inhe replace karna hoga actual screens se
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash Screen')),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login Screen')),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home Screen')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile Screen')),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings Screen')),
    );
  }
}