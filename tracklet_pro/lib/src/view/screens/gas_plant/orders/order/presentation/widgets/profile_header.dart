import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
// Removed unused AppIcons import
// Removed unused CustomSvgIcon import
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/download_report_dialog.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Orders History",
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22),
        ),
        const SizedBox(width: 10),
        CustomButtonWidget(
          type: ButtonType.full,
          text: "Download Report",
          backgroundColor: AppColors.lightBlue,
          textColor: AppColors.darkBlue,
          onPressed: () async {
            final result = await showDownloadReportDialog(context);
            // Check if context is still mounted after async operation
            if (result != null && context.mounted) {
              CustomFlushbar.showInfo(
                context,
                message: 'Export: ${result.isDaily ? 'Daily' : 'Custom'} - ${result.date.day.toString().padLeft(2, '0')}-${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][result.date.month - 1]}-${(result.date.year % 100).toString().padLeft(2, '0')}',
              );
            }
          },
        ),
      ],
    );
  }
}