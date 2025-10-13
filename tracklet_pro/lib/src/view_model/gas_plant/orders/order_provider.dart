import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/order.dart';

/// Provider for Gas Plant Orders
/// Handles state management for order-related UI
class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // Get orders by status
  List<Order> get newOrders => _orders
      .where(
        (order) =>
            order.status == null || order.status?.toLowerCase() == 'pending',
      )
      .toList();

  List<Order> get previousOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'accepted')
      .toList();

  List<Order> get completedOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'completed')
      .toList();

  List<Order> get cancelledOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'cancelled')
      .toList();

  List<Order> get rejectedOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'rejected')
      .toList();

  // Update orders from view model
  void updateOrders(List<Order> orders) {
    _orders = orders;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Notify listeners for UI update
  void refresh() {
    notifyListeners();
  }
}
