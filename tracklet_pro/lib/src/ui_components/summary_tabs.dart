import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/widget/index.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/model/dashboard_tab.dart';

class SummaryTabs extends StatelessWidget {
  final List<DashboardTab> tabs;

  const SummaryTabs({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: AppColors.onBackground,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.lightBlue.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSvgIcon(
                  assetName: _getSvgIconForTab(tab.icon),
                  width: 24,
                  height: 24,
                  color: AppColors.darkBlue,
                  fallbackIcon: tab.icon,
                ),
                const SizedBox(height: 8),
                BodyText(
                  tab.title,
                  style: const TextStyle(
                    color: AppColors.disabledTextColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                HeadingText(
                  tab.value,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getSvgIconForTab(IconData icon) {
    // Map Material icons to SVG icons
    if (icon == Icons.inventory) {
      return AppIcons.svgInventory;
    } else if (icon == Icons.person) {
      return AppIcons.svgProfile;
    } else if (icon == Icons.receipt_long) {
      return AppIcons.svgReceipt;
    }
    return AppIcons.svgDashboard;
  }
}