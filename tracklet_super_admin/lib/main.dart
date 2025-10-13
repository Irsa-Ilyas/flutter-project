import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_super_admin/src/providers/auth_provider.dart';
import 'package:tracklet_super_admin/src/providers/dashboard_provider.dart';
import 'package:tracklet_super_admin/src/providers/users_provider.dart';
import 'package:tracklet_super_admin/src/screens/login_screen.dart';
import 'package:tracklet_super_admin/src/screens/dashboard_screen.dart';
import 'package:tracklet_super_admin/src/utils/app_theme.dart';
import 'package:tracklet_super_admin/src/utils/app_constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isAuthenticated) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
