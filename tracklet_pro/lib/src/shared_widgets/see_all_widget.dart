import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback onTap;

  const SeeAllButton({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softBlue, // Replaced primary with darkBlue
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.only(
            right: 12,
            left: 12,
            bottom: 4,
            top: 4,
          ),
          child: Text("See all", style: TextStyle(color: AppColors.onBackground,fontSize: 14)), // Replaced onPrimary with onBackground
        ),
      ),
    );
  }
}