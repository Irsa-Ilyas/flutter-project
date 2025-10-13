import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view_model/navigation_view_model.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

/// CustomBottomNavBar - Yeh ek custom bottom navigation bar hai jo:
/// - Selected item ko enable karta hai aur baki sab items ko disable
/// - Custom styling karta hai
/// - SVG icons ke sath kaam karta hai
///
/// Features:
/// - Selected item is visually highlighted with border and stronger colors
/// - Unselected items appear dimmed and disabled
/// - Only unselected items are tappable
/// - Clear visual distinction between enabled/disabled states
/// - Custom colors and responsive design
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.3),
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
                iconAsset: AppIcons.svgOrders,
                label: 'Orders',
                index: 1,
                currentIndex: navigationViewModel.currentIndex,
              ),
              _buildNavItem(
                context: context,
                iconAsset: AppIcons.svgProfile,
                label: 'Profile',
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
      onTap: isSelected ? null : () {
        Provider.of<NavigationViewModel>(context, listen: false).navigateToIndex(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.darkBlue.withValues(alpha: 0.2) 
              : AppColors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: isSelected
              ? Border.all(color: AppColors.darkBlue, width: 2)
              : Border.all(color: AppColors.disabledTextColor.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomSvgIcon(
              assetName: iconAsset,
              width: 28,
              height: 28,
              color: isSelected 
                  ? AppColors.darkBlue 
                  : AppColors.disabledTextColor.withValues(alpha: 0.5),
              fallbackIcon: _getFallbackIcon(index),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected 
                    ? AppColors.darkBlue 
                    : AppColors.disabledTextColor.withValues(alpha: 0.5),
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
        return AppIcons.orders;
      case 2:
        return AppIcons.profile;
      case 3:
        return AppIcons.settings;
      default:
        return Icons.circle;
    }
  }
}