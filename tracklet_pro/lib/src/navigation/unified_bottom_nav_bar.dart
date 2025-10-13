import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view_model/navigation_view_model.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

/// Unified Bottom Navigation Bar
/// Yeh automatically detect karta hai ke user Gas Plant hai ya Distributor
/// Aur us ke according tabs show karta hai
class UnifiedBottomNavBar extends StatelessWidget {
  const UnifiedBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final navigationViewModel = Provider.of<NavigationViewModel>(context);
    
    final userRole = authProvider.user?.role ?? 'user';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.onBackground,
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavItems(
              context,
              userRole,
              navigationViewModel.currentIndex,
            ),
          ),
        ),
      ),
    );
  }

  /// Build navigation items based on user role
  List<Widget> _buildNavItems(
    BuildContext context,
    String role,
    int currentIndex,
  ) {
    if (role == 'gas_plant') {
      // Gas Plant: 5 tabs
      return [
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgDashboard,
          label: 'Home',
          index: 0,
          currentIndex: currentIndex,
          fallbackIcon: Icons.home,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgAttachMoney,
          label: 'Gas Rates',
          index: 1,
          currentIndex: currentIndex,
          fallbackIcon: Icons.local_gas_station,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgOrders,
          label: 'Orders',
          index: 2,
          currentIndex: currentIndex,
          fallbackIcon: Icons.list,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgReceipt,
          label: 'Expense',
          index: 3,
          currentIndex: currentIndex,
          fallbackIcon: Icons.money,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgSettings,
          label: 'Settings',
          index: 4,
          currentIndex: currentIndex,
          fallbackIcon: Icons.settings,
        ),
      ];
    } else {
      // Distributor: 4 tabs
      return [
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgDashboard,
          label: 'Home',
          index: 0,
          currentIndex: currentIndex,
          fallbackIcon: Icons.home,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgOrders,
          label: 'Orders',
          index: 1,
          currentIndex: currentIndex,
          fallbackIcon: Icons.list,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgProfile,
          label: 'Drivers',
          index: 2,
          currentIndex: currentIndex,
          fallbackIcon: Icons.people,
        ),
        _buildNavItem(
          context: context,
          iconAsset: AppIcons.svgSettings,
          label: 'Settings',
          index: 3,
          currentIndex: currentIndex,
          fallbackIcon: Icons.settings,
        ),
      ];
    }
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String iconAsset,
    required String label,
    required int index,
    required int currentIndex,
    required IconData fallbackIcon,
  }) {
    final bool isSelected = index == currentIndex;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<NavigationViewModel>(context, listen: false)
              .navigateToIndex(index);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.darkBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSvgIcon(
                assetName: iconAsset,
                width: 24,
                height: 24,
                color: isSelected
                    ? AppColors.darkBlue
                    : AppColors.disabledTextColor,
                fallbackIcon: fallbackIcon,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.darkBlue
                      : AppColors.disabledTextColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

