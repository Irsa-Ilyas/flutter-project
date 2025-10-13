import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';

class OrderTabButton extends StatelessWidget {
  final String text;
  final bool isActive;
  final VoidCallback onTap;

  const OrderTabButton({
    super.key,
    required this.text,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 155,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.darkBlueVariant : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? AppColors.onBackground : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.lightBlue : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomSvgIcon(
                    assetName: AppIcons.svgOrders,
                    width: 20,
                    height: 20,
                    color: isActive ? AppColors.onBackground : Colors.black87,
                    fallbackIcon: AppIcons.orders,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}