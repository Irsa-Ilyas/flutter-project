import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/log_out_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final logoutProvider = context.watch<LogoutProvider?>();

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: CustomButtonWidget(
        type: ButtonType.full,
        text: 'Logout',
        backgroundColor: AppColors.darkBlueVariant,
        isLoading: logoutProvider?.isLoggingOut ?? false,
        onPressed: () async {
          if (logoutProvider != null && !logoutProvider.isLoggingOut) {
            final success = await logoutProvider.logout(context);
            if (success && context.mounted) {
              // Navigate to login screen
              logoutProvider.navigateToLogin(context);
            }
          }
        },
      ),
    );
  }
}