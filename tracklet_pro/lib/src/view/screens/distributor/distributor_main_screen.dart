import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/drivers/distibutor_driver_screen.dart';
import 'package:tracklet_pro/src/view/screens/distributor/orders/distributor_orders_Screen.dart';
import 'package:tracklet_pro/src/view_model/index.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/dashboard_screen.dart';
import 'package:tracklet_pro/src/view/screens/distributor/settings/settings_screen.dart';
import 'package:tracklet_pro/src/navigation/distributor_bottom_nav_bar.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_app_bar.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

class DistributorMainScreen extends StatelessWidget {
  const DistributorMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    // Sample pages for distributor with 4 tabs (Home, Orders, Drivers, Settings)
    final List<Widget> pages = [
      const DistributorDashboardScreen(),
      const DistributorOrdersScreen(),
      const DistibutorDriverScreen(),
      const DistributorSettingsScreen(),
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
        showNotificationIcon: false,
        showMessageIcon: false,
        useDistributorProfile: true,
      ),
      body: pages[navigationViewModel.currentIndex],
      bottomNavigationBar: const DistributorBottomNavBar(),
    );
  }
}
