import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/log_out_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/plant_management/plant_management_screen.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/screens/sales_summary.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/screens/change_password.dart';

/// Provider for Settings screen state
class SettingProvider extends ChangeNotifier {
  String userName = 'Bilal Ahmed';
  String get initials => _makeInitials(userName);

  bool isUrdu = false; // false = Eng, true = Urdu

  void toggleLanguage(bool value) {
    isUrdu = value;
    notifyListeners();
  }

  Future<void> onManagePlant(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PlantManagementScreen()));
  }

  Future<void> onSalesSummary(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SalesSummaryScreen()));
  }

  Future<void> onProfileSettings() async {
    // Navigate to profile settings screen
    // Note: This method doesn't need context since it's called from a StatelessWidget
    // The navigation will be handled by the UI component that calls this method
  }

  Future<void> onChangePassword(BuildContext context) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ChangePasswordScreen()));
  }

  Future<void> onDownloadReports(BuildContext context) async {}

  Future<void> onLegalNotice(BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Legal Notice tapped')));
  }

  Future<void> onPrivacyPolicy(BuildContext context) async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Privacy Policy tapped')));
  }

  Future<void> logout(BuildContext context) async {
    // Use LogoutProvider for logout functionality
    final logoutProvider = Provider.of<LogoutProvider>(context, listen: false);
    await logoutProvider.performLogout(context);
  }

  String _makeInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r"\s+"))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
