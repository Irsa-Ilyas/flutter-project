import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';

class CompletedTabButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;
  const CompletedTabButton({super.key, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onSurface = scheme.onSurface.withValues(alpha: 0.8);
    final bg = isActive ? scheme.primary : scheme.surfaceContainer.withValues(alpha: 0.6);
    final circleBg = isActive ? scheme.onPrimary.withValues(alpha: 0.8) : scheme.surfaceContainer;
    final textColor = isActive ? scheme.onPrimary : onSurface;
    final iconColor = isActive ? scheme.primary : onSurface;
    return SizedBox(
      height: 48,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 155,
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  'Completed',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ) ??
                      TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              Container(
                width: 37,
                height: 37,
                decoration: BoxDecoration(
                  color: circleBg,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: CustomSvgIcon(
                    assetName: AppIcons.svgOrders,
                    width: 20,
                    height: 20,
                    color: iconColor,
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
