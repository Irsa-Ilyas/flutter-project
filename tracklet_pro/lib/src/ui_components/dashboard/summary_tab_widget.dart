import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/model/dashboard_summary.dart';

/// A customizable summary tab with animated selection states
/// This widget can work with both static data and API data
class SummaryTab extends StatelessWidget {
  final String value;
  final String label;
  final String iconPath;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final String headerTop;
  final String headerBottom;
  
  // Optional: For direct DashboardSummary usage
  final DashboardSummary? summaryData;

  const SummaryTab({
    super.key,
    required this.value,
    required this.label,
    required this.iconPath,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.headerTop,
    required this.headerBottom,
    this.summaryData,
  });

  // Factory constructor for creating from DashboardSummary
  factory SummaryTab.fromSummaryData({
    required DashboardSummary summary,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return SummaryTab(
      value: summary.value,
      label: summary.unit,
      iconPath: summary.iconPath,
      color: summary.color,
      isSelected: isSelected,
      onTap: onTap,
      headerTop: summary.title,
      headerBottom: summary.description,
      summaryData: summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        key: const ValueKey('summary_tab'),
        height: 100,
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.disabledTextColor),
          color: isSelected ? color : AppTheme.lightTheme.cardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const Spacer(),
            _buildValue(),
            const SizedBox(height: 4),
            _buildLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              headerTop,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.cardColor
                    : AppColors.darkBlue,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              headerBottom,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.cardColor
                    : AppColors.darkBlue,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
        _buildIcon(),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.softBlue : AppColors.softBlue,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: CustomSvgIcon(
        assetName: iconPath,
        width: 20,
        height: 20,
        color: isSelected ? AppTheme.lightTheme.cardColor : color,
        fallbackIcon: _getFallbackIcon(iconPath),
      ),
    );
  }

  Widget _buildValue() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        value,
        style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
          color: isSelected
              ? AppTheme.lightTheme.cardColor
              : AppColors.darkBlue,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      label,
      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
        color: isSelected ? AppTheme.lightTheme.cardColor : AppColors.darkBlue,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  IconData _getFallbackIcon(String iconPath) {
    // Map SVG paths to fallback Material icons
    if (iconPath.contains('inventory')) {
      return Icons.inventory;
    } else if (iconPath.contains('profile')) {
      return Icons.person;
    } else if (iconPath.contains('receipt')) {
      return Icons.receipt_long;
    } else if (iconPath.contains('dashboard')) {
      return Icons.dashboard;
    } else if (iconPath.contains('orders')) {
      return Icons.list;
    } else if (iconPath.contains('settings')) {
      return Icons.settings;
    } else if (iconPath.contains('search')) {
      return Icons.search;
    } else if (iconPath.contains('add')) {
      return Icons.add;
    } else if (iconPath.contains('logout')) {
      return Icons.logout;
    }
    return Icons.help; // Default fallback
  }
}