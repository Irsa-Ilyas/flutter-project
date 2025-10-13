import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view_model/navigation_view_model.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_app_bar.dart';
import 'package:tracklet_pro/src/navigation/unified_bottom_nav_bar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

// Gas Plant Screens
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/dashboard_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/gas_rates_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/orders_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/expense_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/setting_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/notifications/notifications_screen.dart';

// Distributor Screens
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/dashboard_screen.dart';
import 'package:tracklet_pro/src/view/screens/distributor/orders/distributor_orders_Screen.dart';
import 'package:tracklet_pro/src/view/screens/distributor/drivers/distibutor_driver_screen.dart';
import 'package:tracklet_pro/src/view/screens/distributor/settings/settings_screen.dart';

/// Unified Main Screen - Yeh screen automatically detect karta hai ke user Gas Plant hai ya Distributor
/// Aur us ke according appropriate screens aur navigation show karta hai
class UnifiedMainScreen extends StatelessWidget {
  const UnifiedMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);

    // User info
    final user = authProvider.user;
    final userName = user?.name ?? 'User';
    final userRole = user?.role ?? 'user';
    final userInitials = userName
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    // Get pages based on user role
    final pages = _getPages(userRole);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      appBar: CustomAppBar(
        userName: userName,
        userInitials: userInitials,
        showNotificationIcon: userRole == 'gas_plant',
        showMessageIcon: false,
        useDistributorProfile: userRole == 'distributor',
        onNotificationPressed: userRole == 'gas_plant'
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              }
            : null,
      ),
      body: pages[navigationViewModel.currentIndex],
      bottomNavigationBar: const UnifiedBottomNavBar(),
    );
  }

  /// Get pages based on user role
  List<Widget> _getPages(String role) {
    if (role == 'gas_plant') {
      return const [
        GasPlantDashboardScreen(),
        GasPlantGasRatesScreen(),
        GasPlantOrdersScreen(),
        GasPlantExpenseScreen(),
        SettingScreen(),
      ];
    } else {
      // Distributor
      return const [
        DistributorDashboardScreen(),
        DistributorOrdersScreen(),
        DistibutorDriverScreen(),
        DistributorSettingsScreen(),
      ];
    }
  }
}

