import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/ui_components/section_header_widget.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/employee/index.dart';
import 'package:tracklet_pro/src/view_model/index.dart';
import 'package:tracklet_pro/src/ui_components/dashboard/plant_summary_row.dart';
import 'package:tracklet_pro/src/ui_components/dashboard/gas_plant_order_card.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/orders_in_progress/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/active_employees_screen.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/providers/gas_plant_orders_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';

class GasPlantDashboardScreen extends StatefulWidget {
  const GasPlantDashboardScreen({super.key});

  @override
  State<GasPlantDashboardScreen> createState() =>
      _GasPlantDashboardScreenState();
}

class _GasPlantDashboardScreenState extends State<GasPlantDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardViewModel = Provider.of<GasPlantDashboardViewModel>(
        context,
        listen: false,
      );
      if (dashboardViewModel.summaryData.isEmpty) {
        dashboardViewModel.loadDashboardData();
      }

      // Fetch real orders from backend
      final authProvider = context.read<AuthProvider>();
      final ordersProvider = context.read<GasPlantOrdersProvider>();
      final plantId = authProvider.user?.id ?? 'default_plant';
      ordersProvider.fetchOrders(plantId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GasPlantDashboardViewModel, GasPlantOrdersProvider>(
      builder: (context, dashboardViewModel, ordersProvider, child) {
        return Scaffold(
          backgroundColor: AppColors.lightBlueBackground,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeaderWidget(
                    title: AppStrings.dashboard,
                    seeAllText: AppStrings.viewAll,
                    onSeeAllPressed: () {
                      // Handle see all
                    },
                  ),
                  // Use the new data-driven PlantSummaryRow
                  PlantSummaryRow(
                    summaryData: dashboardViewModel.summaryData,
                    selectedTabs: List.generate(
                      dashboardViewModel.summaryData.length,
                      (index) => index == dashboardViewModel.selectedTabIndex,
                    ),
                    onTabSelected: (index) {
                      dashboardViewModel.selectTab(index);
                      // Navigate to the appropriate screen based on the selected tab
                      if (context.mounted) {
                        _navigateToDetailScreen(context, index);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Active Employees Button
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomButtonWidget(
                      type: ButtonType.small,
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ActiveEmployeesScreen(),
                            ),
                          );
                        }
                      },
                      text: AppStrings.viewActiveEmployees,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        AppStrings.newOrders,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      CustomButtonWidget(
                        type: ButtonType.small,
                        onPressed: () {
                          // Navigate to all orders screen
                          if (context.mounted) {
                            // Add navigation logic here when implemented
                          }
                        },
                        text: AppStrings.seeAll,
                      ),
                    ],
                  ),
                  // NEW ORDERS SECTION (Pending)
                  ...ordersProvider.newOrders.map(
                    (o) => GasPlantOrderCard(
                      order: o,
                      isNew: true,
                      onAccept: () async {
                        // Fixing warning: The operand can't be 'null', so the condition is always 'true'
                        // Since we're checking if o.id == null, but the analyzer says it can't be null,
                        // we should handle this properly
                        if (o.id == null) return;
                        final success = await ordersProvider.acceptOrder(o.id!);
                        if (success && context.mounted) {
                          final authProvider = context.read<AuthProvider>();
                          final stockProvider = context.read<StockProvider>();
                          final rateProvider = context.read<RateProvider>();

                          // Deduct stock from tanks
                          // Fixing warning: The operand can't be 'null', so the condition is always 'true'
                          if (o.totalKg > 0) {
                            final plantId =
                                authProvider.user?.id ?? 'default_plant';
                            await stockProvider.deductStockForOrder(
                              ownerId: plantId,
                              amountInKg: o.totalKg,
                              rate: rateProvider.todayRate.toDouble(),
                              orderId: o.id!,
                            );
                          }

                          ordersProvider.fetchOrders(
                            authProvider.user?.id ?? 'default_plant',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order accepted & stock deducted'),
                            ),
                          );
                        }
                      },
                      onReject: () async {
                        // Fixing warning: The operand can't be 'null', so the condition is always 'true'
                        if (o.id == null) return;
                        final success = await ordersProvider.rejectOrder(o.id!);
                        if (success && context.mounted) {
                          final authProvider = context.read<AuthProvider>();
                          ordersProvider.fetchOrders(
                            authProvider.user?.id ?? 'default_plant',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Order rejected')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        AppStrings.previousOrders,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      CustomButtonWidget(
                        type: ButtonType.small,
                        onPressed: () {
                          if (context.mounted) {
                            // Navigate to Orders screen to see all accepted orders
                          }
                        },
                        text: AppStrings.seeAll,
                      ),
                    ],
                  ),
                  // PREVIOUS ORDERS SECTION (Accepted - shown on dashboard only)
                  ...ordersProvider.previousOrders.map(
                    (o) => GasPlantOrderCard(
                      order: o,
                      onAccept: () {
                        // Previous orders are already accepted, just for display

                      },
                      onReject: () {

                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Note: Completed, Cancelled, and Rejected orders are ONLY shown in Orders screen (bottom navbar)
                  // They should NOT appear on dashboard
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetailScreen(BuildContext context, int index) {
    if (!context.mounted) return;

    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TotalStockScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmployeeScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OrdersInProgressScreen(),
          ),
        );
        break;
    }
  }
}
