import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/order_model.dart';

/// Provider for Distributor Orders
/// Handles state management for distributor order-related UI
class DistributorOrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<OrderModel> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Approved orders only
  List<OrderModel> get approvedOrders {
    return _orders.where((order) => order.status == 'Approved').toList();
  }

  // Pending orders
  List<OrderModel> get pendingOrders {
    return _orders.where((order) => order.status == 'Pending').toList();
  }

  // Update orders from view model
  void updateOrders(List<OrderModel> orders) {
    _orders = orders;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Update single order
  void updateOrder(String orderId, OrderModel updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  // Refresh
  void refresh() {
    notifyListeners();
  }
}
