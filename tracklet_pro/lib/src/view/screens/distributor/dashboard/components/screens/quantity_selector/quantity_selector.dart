import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/distributor_request_view_model.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

class QuantitySelector extends StatelessWidget {
  final int weight;

  const QuantitySelector({
    super.key,
    required this.weight,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DistributorRequestViewModel>(context);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$weight ${AppStrings.kg}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Row(
          children: [
            // --- Decrease Button ---
            GestureDetector(
              onTap: () => provider.decreaseQuantity(weight.toDouble()),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.darkBlue,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 12,
                  height: 2,
                  color: AppColors.darkBlue,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // --- Fixed Width Text (Prevent layout shifting) ---
            SizedBox(
              width: 30, // fix width taake icons move na karein
              child: Center(
                child: Text(
                  '${provider.getQuantity(weight.toDouble())}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // --- Increase Button ---
            GestureDetector(
              onTap: () => provider.increaseQuantity(weight.toDouble()),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.darkBlue,
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: CustomSvgIcon(
                  assetName: AppIcons.svgAdd,
                  width: 14,
                  height: 14,
                  color: AppColors.darkBlue,
                  fallbackIcon: Icons.add,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
