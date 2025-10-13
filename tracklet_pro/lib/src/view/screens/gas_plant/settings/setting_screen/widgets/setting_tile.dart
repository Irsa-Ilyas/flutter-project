import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
// Removed unused AppIcons import

class SettingTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const SettingTile({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.lightBlueBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightBlue),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, color: AppColors.darkBlue, fontWeight: FontWeight.w500),
              ),
            ),
            CustomSvgIcon(
              assetName: 'lib/src/assets/svg/chevron_right.svg', // Placeholder - needs to be created
              width: 24,
              height: 24,
              color: AppColors.navyBlue,
              fallbackIcon: Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}