import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view_model/navigation_view_model.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

/// DistributorBottomNavBar - Yeh distributor ke liye custom bottom navigation bar hai jo:
/// - Home, Orders, Drivers, Settings tabs display karta hai
/// - Active tab highlight karta hai
/// - Custom styling karta hai
/// - SVG icons ke sath kaam karta hai
///
/// Features:
/// - Custom SVG icons
/// - Active state tracking
/// - Custom colors
/// - Responsive design
class DistributorBottomNavBar extends StatelessWidget {
  const DistributorBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context: context,
              iconAsset: AppIcons.svgDashboard,
              label: 'Home',
              index: 0,
              currentIndex: navigationViewModel.currentIndex,
            ),
            _buildNavItem(
              context: context,
              iconAsset: AppIcons.svgOrders,
              label: 'Orders',
              index: 1,
              currentIndex: navigationViewModel.currentIndex,
            ),
            _buildNavItem(
              context: context,
              iconAsset: AppIcons.svgProfile, // Using profile icon as driver icon
              label: 'Drivers',
              index: 2,
              currentIndex: navigationViewModel.currentIndex,
            ),
            _buildNavItem(
              context: context,
              iconAsset: AppIcons.svgSettings,
              label: 'Settings',
              index: 3,
              currentIndex: navigationViewModel.currentIndex,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String iconAsset,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final bool isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: () {
        Provider.of<NavigationViewModel>(context, listen: false).navigateToIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
       
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: iconAsset,
              width: 24,
              height: 24,
              color: isSelected ? AppColors.onBackground : AppColors.disabledTextColor,
              fallbackIcon: _getFallbackIcon(index),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.onBackground : AppColors.disabledTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFallbackIcon(int index) {
    switch (index) {
      case 0:
        return AppIcons.dashboard;
      case 1:
        return AppIcons.distributorOrders;
      case 2:
        return AppIcons.profile; // Using profile icon as driver icon
      case 3:
        return AppIcons.settings;
      default:
        return Icons.circle;
    }
  }
}