import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view_model/navigation_view_model.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

/// GasPlantBottomNavBar - Yeh gas plant ke liye custom bottom navigation bar hai jo:
/// - Home, Gas Rates, Orders, Expense, Settings tabs display karta hai
/// - Active tab highlight karta hai
/// - Custom styling karta hai
/// - SVG icons ke sath kaam karta hai
///
/// Features:
/// - Custom SVG icons
/// - Active state tracking
/// - Custom colors
/// - Responsive design
class GasPlantBottomNavBar extends StatelessWidget {
  const GasPlantBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.3), // Using AppColors with opacity
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
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
                iconAsset: AppIcons.svgSearch, // Using search icon as placeholder for gas rates
                label: 'Gas Rates',
                index: 1,
                currentIndex: navigationViewModel.currentIndex,
              ),
              _buildNavItem(
                context: context,
                iconAsset: AppIcons.svgOrders,
                label: 'Orders',
                index: 2,
                currentIndex: navigationViewModel.currentIndex,
              ),
              _buildNavItem(
                context: context,
                iconAsset: AppIcons.svgAdd, // Using add icon as placeholder for expense
                label: 'Expense',
                index: 3,
                currentIndex: navigationViewModel.currentIndex,
              ),
              _buildNavItem(
                context: context,
                iconAsset: AppIcons.svgSettings,
                label: 'Settings',
                index: 4,
                currentIndex: navigationViewModel.currentIndex,
              ),
            ],
          ),
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
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkBlue.withValues(alpha: 0.1) : AppColors.transparent, // Using AppColors with opacity
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: iconAsset,
              width: 24,
              height: 24,
              color: isSelected ? AppColors.darkBlue : AppColors.disabledTextColor,
              fallbackIcon: _getFallbackIcon(index),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.darkBlue : AppColors.disabledTextColor,
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
        return Icons.local_gas_station; // Gas rates icon
      case 2:
        return AppIcons.orders;
      case 3:
        return AppIcons.add; // Expense icon
      case 4:
        return AppIcons.settings;
      default:
        return Icons.circle;
    }
  }
}