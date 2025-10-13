import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

// Distributor settings screen - yeh screen distributor ke settings options dikhata hai
class DistributorSettingsScreen extends StatelessWidget {
  const DistributorSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.lightBlue,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Time
        
                
      
                
                // Arham Traders
                Text(
                  'Arham Traders',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 5),
                
                // Email or additional info
                Text(
                  'arham.traders@example.com',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.disabledTextColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Settings options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Account settings section
                Text(
                  '${AppStrings.account} ${AppStrings.settings}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Profile settings card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        icon: Icons.person,
                        title: '${AppStrings.profile} ${AppStrings.information}',
                        subtitle: '${AppStrings.update} ${AppStrings.your} ${AppStrings.profile} ${AppStrings.details}',
                        onTap: () {
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        context,
                        icon: Icons.lock,
                        title: AppStrings.security,
                        subtitle: '${AppStrings.change} ${AppStrings.password} ${AppStrings.and} ${AppStrings.security} ${AppStrings.settings}',
                        onTap: () {
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        context,
                        icon: Icons.notifications,
                        title: AppStrings.notifications,
                        subtitle: '${AppStrings.manage} ${AppStrings.notification} ${AppStrings.preferences}',
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // App settings section
                Text(
                  '${AppStrings.app} ${AppStrings.settings}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                
                // App settings card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        icon: Icons.language,
                        title: AppStrings.language,
                        subtitle: '${AppStrings.select} ${AppStrings.your} ${AppStrings.preferred} ${AppStrings.language}',
                        onTap: () {
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        context,
                        icon: Icons.dark_mode,
                        title: '${AppStrings.dark} ${AppStrings.mode}',
                        subtitle: '${AppStrings.switchText} ${AppStrings.between} ${AppStrings.light} ${AppStrings.and} ${AppStrings.dark} ${AppStrings.theme}',
                        trailing: Switch(
                          value: false, 
                          onChanged: (value) {
                          },
                          activeThumbColor: AppColors.darkBlue,
                        ),
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Support section
                Text(
                  AppStrings.support,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 10),
                
                // Support card
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSettingsItem(
                        context,
                        icon: Icons.help,
                        title: '${AppStrings.help} & ${AppStrings.support}',
                        subtitle: '${AppStrings.get} ${AppStrings.help} ${AppStrings.withText} ${AppStrings.using} ${AppStrings.the} ${AppStrings.app}',
                        onTap: () {
                        },
                      ),
                      const Divider(height: 1),
                      _buildSettingsItem(
                        context,
                        icon: Icons.info,
                        title: AppStrings.about,
                        subtitle: '${AppStrings.learn} ${AppStrings.more} ${AppStrings.about} ${AppStrings.the} ${AppStrings.app}',
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Logout button
                SizedBox(
                  width: double.infinity,
                  child: CustomButtonWidget(
                    type: ButtonType.full,
                    onPressed: () {
                    },
                    text: AppStrings.logout,
                    backgroundColor: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Settings item widget - yeh widget settings items dikhata hai
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.darkBlue,
        size: 28,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.onBackground,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.disabledTextColor,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.disabledTextColor),
      onTap: onTap,
    );
  }
}