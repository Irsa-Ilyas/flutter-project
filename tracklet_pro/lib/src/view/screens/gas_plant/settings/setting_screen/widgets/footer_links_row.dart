import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

class FooterLinksRow extends StatelessWidget {
  final VoidCallback onLegal;
  final VoidCallback onPrivacy;
  const FooterLinksRow({super.key, required this.onLegal, required this.onPrivacy});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButtonWidget(
          type: ButtonType.tab,
          text: 'Legal Notice',
          backgroundColor: AppColors.transparent,
          textColor: AppColors.onBackground,
          onPressed: onLegal,
        ),
        CustomButtonWidget(
          type: ButtonType.tab,
          text: 'Privacy Policy',
          backgroundColor: AppColors.transparent,
          textColor: AppColors.onBackground,
          onPressed: onPrivacy,
        ),
      ],
    );
  }
}
