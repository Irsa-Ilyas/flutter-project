import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';
import 'package:tracklet_pro/src/view_model/gas_plant_dashboard_view_model.dart';

class SalesSummaryProvider extends ChangeNotifier {
  SalesSummaryProvider(BuildContext context) {
    _calculateSalesData(context);
  }

  // Summary values - calculated from real data
  int totalKgToday = 0;
  int totalAmountToday = 0;

  // Orders overview data (weekly) - calculated from real data
  List<int> weeklyOrders = [0, 0, 0, 0, 0, 0, 0];
  int selectedIndex = 0;

  // Period filter
  String period = 'Weekly';
  final List<String> periods = const ['Weekly', 'Monthly', 'Yearly'];

  void setPeriod(String value) {
    if (period == value) return;
    period = value;
    notifyListeners();
  }

  // Called when an order is approved
  void addApprovedOrder(dynamic order) {
    _calculateSalesData(null);
    notifyListeners();
  }

  // Called when an order is cancelled
  void addCancelledOrder(dynamic order) {
    _calculateSalesData(null);
    notifyListeners();
  }

  void _calculateSalesData(BuildContext? context) {
    // Initialize with zero values
    totalKgToday = 0;
    totalAmountToday = 0;
    weeklyOrders = [0, 0, 0, 0, 0, 0, 0];

    if (context == null) return;

    try {
      // Get GasPlantDashboardViewModel for real order data
      final dashboardViewModel = Provider.of<GasPlantDashboardViewModel>(context, listen: false);
      final rateProvider = Provider.of<RateProvider>(context, listen: false);

      // Get today's date
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);

      // Calculate total KG sold today from new orders
      final newOrders = dashboardViewModel.newOrders.where((order) {
        // Check if order was created today
        return order.dateTime.isAfter(todayStart) || order.dateTime.isAtSameMomentAs(todayStart);
      }).toList();

      totalKgToday = newOrders.fold(0, (sum, order) => sum + order.totalKg.toInt());

      // Calculate total amount using current rate
      final currentRate = rateProvider.todayRate;
      totalAmountToday = (totalKgToday * currentRate).toInt();

      // Calculate weekly orders data
      _calculateWeeklyOrders(dashboardViewModel);

      selectedIndex = _todayIndex();

      debugPrint('📊 Sales Data Calculated:');
      debugPrint('   Total KG Today: $totalKgToday');
      debugPrint('   Total Amount Today: $totalAmountToday');
      debugPrint('   Current Rate: $currentRate');
      debugPrint('   Weekly Orders: $weeklyOrders');

    } catch (e) {
      debugPrint('❌ Error calculating sales data: $e');
      // Keep zero values on error
    }
  }

  void _calculateWeeklyOrders(GasPlantDashboardViewModel dashboardViewModel) {
    final now = DateTime.now();

    // Calculate orders for each day of the week
    for (int i = 0; i < 7; i++) {
      final dayStart = DateTime(now.year, now.month, now.day - (6 - i));
      final dayEnd = DateTime(now.year, now.month, now.day - (6 - i), 23, 59, 59);

      final dayOrders = dashboardViewModel.newOrders.where((order) {
        return order.dateTime.isAfter(dayStart) && order.dateTime.isBefore(dayEnd);
      }).toList();

      weeklyOrders[i] = dayOrders.length;
    }
  }

  int _todayIndex() {
    // DateTime.weekday: Mon=1..Sun=7 -> 0..6
    final w = DateTime.now().weekday;
    return (w - 1).clamp(0, 6);
  }

  // Refresh data (call this when orders change)
  void refreshData(BuildContext context) {
    _calculateSalesData(context);
    notifyListeners();
  }
}
