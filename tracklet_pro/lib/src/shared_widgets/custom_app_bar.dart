import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/notification_provider.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final String? userInitials;
  final List<Widget>? actions;
  final bool showNotificationIcon;
  final bool showMessageIcon;
  final bool useDistributorProfile;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onMessagePressed;
  final VoidCallback? onProfilePressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    this.userName,
    this.userInitials,
    this.actions,
    this.showNotificationIcon = true,
    this.showMessageIcon = true,
    this.useDistributorProfile = false,
    this.onNotificationPressed,
    this.onMessagePressed,
    this.onProfilePressed,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return AppBar(
      backgroundColor: AppColors.lightBlueBackground, // Using onBackground as a substitute for white
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
              icon: CustomSvgIcon(
                assetName: AppIcons.svgArrowBack,
                width: 24,
                height: 24,
                color: AppColors.onBackground, // Using onBackground instead of Colors.black
                fallbackIcon: AppIcons.arrowBack,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: Row(
        children: [
          GestureDetector(
            onTap: onProfilePressed,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.darkBlue, // Replaced brandPrimary with darkBlue
              child: Text(
                userInitials ?? 'U',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.onBackground, // Replaced onPrimary with onBackground
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            userName ?? 'User',
            style: textTheme.titleLarge,
          ),
          const Spacer(),
          if (showNotificationIcon) ...[
            Consumer<NotificationProvider>(
              builder: (context, notificationProvider, child) {
                return Stack(
                  children: [
                    _buildIconButton(
                      context: context,
                      icon: Icons.notifications,
                      onPressed: onNotificationPressed,
                    ),
                    if (notificationProvider.unreadCount > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            notificationProvider.unreadCount > 99 
                                ? '99+' 
                                : notificationProvider.unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white, // This will have to stay as Colors.white since we don't have a white color in AppColors
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          ...?actions,
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required BuildContext context, 
    required IconData icon, 
    VoidCallback? onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue, width: 0.5), // Replaced gray300 with lightBlue
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 20, color: AppColors.disabledTextColor), // Replaced gray700 with disabledTextColor
      ),
    );
  }
}