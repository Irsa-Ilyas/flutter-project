import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/gas_rates_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/orders_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/setting_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/notifications/notifications_screen.dart';
import 'package:tracklet_pro/src/view_model/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/index.dart';
import 'package:tracklet_pro/src/navigation/gas_plant_bottom_nav_bar.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_app_bar.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

class GasPlantMainScreen extends StatelessWidget {
  const GasPlantMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Sample pages for gas plant with 5 tabs
    final List<Widget> pages = [
      const GasPlantDashboardScreen(),
      const GasPlantGasRatesScreen(),
      const GasPlantOrdersScreen(),
      const GasPlantExpenseScreen(),
      const SettingScreen(),
    ];

    // Get user initials
    final userName = authProvider.user?.name ?? 'User';
    final userInitials = userName
        .split(' ')
        .map((word) => word.isNotEmpty ? word[0] : '')
        .take(2)
        .join()
        .toUpperCase();

    return Scaffold(
      appBar: CustomAppBar(
        userName: userName,
        userInitials: userInitials,
        showNotificationIcon: true,
        showMessageIcon: false,
        onNotificationPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationsScreen(),
            ),
          );
        },
      ),
      body: pages[navigationViewModel.currentIndex],
      bottomNavigationBar: const GasPlantBottomNavBar(),
    );
  }
}
