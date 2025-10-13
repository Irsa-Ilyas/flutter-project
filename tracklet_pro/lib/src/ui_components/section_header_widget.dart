import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// SectionHeaderWidget - Yeh ek reusable section header widget hai jo:
/// - Title display karta hai
/// - "See all" button provide karta hai
/// - Custom styling support karta hai
///
/// Features:
/// - Custom title
/// - See all button
/// - On-tap callback
/// - Custom styling
class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllPressed;
  final String seeAllText;
  final Color? titleColor;
  final double titleSize;
  final FontWeight titleWeight;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.onSeeAllPressed,
    this.seeAllText = 'See all',
    this.titleColor,
    this.titleSize = 18,
    this.titleWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor ?? AppColors.onBackground,
            fontSize: titleSize,
            fontWeight: titleWeight,
          ),
        ),
        if (onSeeAllPressed != null)
          CustomButtonWidget(
            type: ButtonType.tab,
            text: seeAllText,
            textColor: AppColors.darkBlue,
            backgroundColor: AppColors.transparent,
            onPressed: onSeeAllPressed!,
          ),
      ],
    );
  }
}