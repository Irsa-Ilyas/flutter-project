import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/add_gas_dialog.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/freeze_gas_dialog.dart';

class TankCard extends StatelessWidget {
  final TankModel tank;

  const TankCard({super.key, required this.tank});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.darkBlue;
    final stockProvider = context.watch<StockProvider>();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                tank.name,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                backgroundColor: Colors.blueGrey[100],
                radius: 14,
                child: CustomSvgIcon(
                  assetName: AppIcons.svgInfo,
                  width: 18,
                  height: 18,
                  color: Colors.blueGrey[700],
                  fallbackIcon: AppIcons.infoOutline,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: tank.isActive ? primaryColor : Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tank.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: [
                const TextSpan(
                  text: "Available: ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: "${tank.available.toStringAsFixed(1)} Tons",
                  style: TextStyle(fontWeight: FontWeight.w700, color: primaryColor),
                ),
                const TextSpan(text: " | "),
                const TextSpan(
                  text: "Freeze: ",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: "${tank.freezeGas.toStringAsFixed(1)} Tons",
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Total Capacity: ${tank.totalCapacity.toStringAsFixed(1)} Tons",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          Text(
            "Last Recorded: ${tank.formattedDate}",
            style: TextStyle(color: Colors.grey[700], fontSize: 13),
          ),
          if (tank.location.isNotEmpty)
            Text(
              "Location: ${tank.location}",
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomButtonWidget(
                  type: ButtonType.tab,
                  text: "Freeze Gas",
                  backgroundColor: Colors.transparent,
                  textColor: Colors.grey[700],
                  onPressed: stockProvider.isFreezingGas || !tank.isActive
                      ? () {}
                      : () => _showFreezeGasDialog(context, tank),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButtonWidget(
                  type: ButtonType.full,
                  text: "Add Gas",
                  backgroundColor: primaryColor,
                  onPressed: stockProvider.isAddingGas || !tank.isActive
                      ? () {}
                      : () => _showAddGasDialog(context, tank),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddGasDialog(BuildContext context, TankModel tank) {
    showDialog(
      context: context,
      builder: (context) => AddGasDialog(tank: tank),
    );
  }

  void _showFreezeGasDialog(BuildContext context, TankModel tank) {
    showDialog(
      context: context,
      builder: (context) => FreezeGasDialog(tank: tank),
    );
  }
}
