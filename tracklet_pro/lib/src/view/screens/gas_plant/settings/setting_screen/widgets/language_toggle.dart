import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class LanguageToggle extends StatelessWidget {
  final bool isUrdu;
  final ValueChanged<bool> onChanged;
  const LanguageToggle({super.key, required this.isUrdu, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ENG',
          style: TextStyle(
            color: isUrdu ? AppColors.disabledTextColor : AppColors.darkBlue,
            fontWeight: isUrdu ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        Switch(
          value: isUrdu,
          onChanged: onChanged,
          activeThumbColor: AppColors.darkBlue,
          activeTrackColor: AppColors.lightBlue,
        ),
        const SizedBox(width: 12),
        Text(
          'اردو',
          style: TextStyle(
            color: isUrdu ? AppColors.darkBlue : AppColors.disabledTextColor,
            fontWeight: isUrdu ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
