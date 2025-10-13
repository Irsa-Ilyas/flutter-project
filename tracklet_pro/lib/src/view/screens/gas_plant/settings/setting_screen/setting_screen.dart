import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/download_report_dialog.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/setting_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/screens/profile_setting.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/setting_tile.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/language_toggle.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/footer_links_row.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/logout_button.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/notifications/notifications_screen.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
// Removed unused AppIcons import
import 'package:tracklet_pro/src/utils/app_colors.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SettingView();
  }
}

class _SettingView extends StatelessWidget {
  const _SettingView();

  @override
  Widget build(BuildContext context) {
    // Providers are now provided by AppProviders at the root level
    // We can access them directly through context
    final settingProvider = context.watch<SettingProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header (avatar, name, actions)
              Consumer<AuthProvider>(
                builder: (context, authProvider, _) {
                  final user = authProvider.user;
                  return Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: AppColors.darkBlue,
                        backgroundImage: user?.profileImageUrl.isNotEmpty == true
                            ? NetworkImage(user!.profileImageUrl)
                            : null,
                        child: user?.profileImageUrl.isEmpty != false
                            ? Text(
                                user?.initials ?? 'U',
                                style: const TextStyle(
                                  color: AppColors.lightBlueBackground,
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          user?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onBackground,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  IconButton(
                    onPressed: () {
                  
                    },
                    icon: CustomSvgIcon(
                      assetName: 'lib/src/assets/svg/chat.svg', // Placeholder - needs to be created
                      width: 24,
                      height: 24,
                      color: AppColors.lightBlueBackground,
                      fallbackIcon: Icons.chat_bubble_outline,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsScreen(),
                        ),
                      );
                    },
                    icon: CustomSvgIcon(
                      assetName: 'lib/src/assets/svg/notification.svg', // Placeholder - needs to be created
                      width: 24,
                      height: 24,
                      color: AppColors.disabledTextColor,
                      fallbackIcon: Icons.notifications_none_rounded,
                    ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),

              // Title
              Text('Setting', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 12),

              // Setting tiles
              SettingTile(title: 'Manage Plant', onTap: () => settingProvider.onManagePlant(context)),
              const SizedBox(height: 10),
              SettingTile(title: 'Sales Summary', onTap: () => settingProvider.onSalesSummary(context)),
              const SizedBox(height: 10),
              SettingTile(title: 'Profile Settings', onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileSettingScreen()),
                );
              }),
              const SizedBox(height: 10),
              SettingTile(
                title: 'Change Password',
                onTap: () => settingProvider.onChangePassword(context),
              ),
              const SizedBox(height: 10),
              SettingTile(
                title: 'Download Reports',
                onTap: () async {
                  final result = await showDownloadReportDialog(context);
                  if (result != null && context.mounted) {
                    CustomFlushbar.showInfo(
                      context,
                      message: 'Export: ${result.isDaily ? 'Daily' : 'Custom'} - ${result.date.day.toString().padLeft(2, '0')}-${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][result.date.month - 1]}-${(result.date.year % 100).toString().padLeft(2, '0')}',
                    );
                  }
                },
              ),

              const SizedBox(height: 20),
              Text('Language', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  LanguageToggle(
                    isUrdu: settingProvider.isUrdu,
                    onChanged: settingProvider.toggleLanguage,
                  ),
                ],
              ),

              const SizedBox(height: 8),
              FooterLinksRow(
                onLegal: () => settingProvider.onLegalNotice(context),
                onPrivacy: () => settingProvider.onPrivacyPolicy(context),
              ),

              const SizedBox(height: 12),
              const LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}