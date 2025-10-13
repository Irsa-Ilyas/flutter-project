import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';
import 'package:tracklet_pro/src/providers/gas_plant_orders_provider.dart';
import 'package:tracklet_pro/src/providers/plant_provider.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/view_model/index.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/setting_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/log_out_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/manage_plant_provider.dart';
import 'package:tracklet_pro/src/providers/notification_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/providers/expense_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/employee/provider/employee_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/provider/order_provider.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RateProvider()),
        ChangeNotifierProvider(create: (_) => GasPlantOrdersProvider()),
        ChangeNotifierProvider(create: (_) => PlantProvider()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
        ChangeNotifierProvider(create: (_) => LanguageViewModel()),
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
        ChangeNotifierProvider(create: (_) => GasPlantDashboardViewModel()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
        ChangeNotifierProvider(create: (_) => SettingProvider()),
        ChangeNotifierProvider(create: (_) => LogoutProvider()),
        ChangeNotifierProvider(create: (_) => ManagePlantProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => DistributorRequestViewModel()),
        ChangeNotifierProvider(create: (_) => DriverScreenProvider()),
        ChangeNotifierProvider(create: (_) => DistributorOrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        // SalesSummaryProvider needs context, so we'll create it with a factory
        // Add more providers as needed for each screen
      ],
      child: child,
    );
  }
}
