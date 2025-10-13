import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/service/order_service.dart';
import 'package:tracklet_pro/src/model/order.dart';

class OrderProvider extends BaseViewModel {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  String? _errorMessage;
  bool _isCompletedTab = true; // Default to Completed tab

  // Getters
  List<Order> get orders {
    // Filter based on active tab
    if (_isCompletedTab) {
      return _orders
          .where((o) => o.status?.toLowerCase() == 'completed')
          .toList();
    } else {
      return _orders
          .where((o) => o.status?.toLowerCase() == 'cancelled')
          .toList();
    }
  }

  // Get accepted orders (for showing in Orders screen with Complete/Cancel buttons)
  List<Order> get acceptedOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'accepted')
      .toList();

  String? get errorMessage => _errorMessage;
  bool get isCompletedTab => _isCompletedTab;

  // Fetch orders for a plant
  Future<void> fetchOrders(String plantId) async {
    setLoading(true);
    _errorMessage = null;
    notifyListeners();

    try {
      _orders = await _orderService.getPlantOrders(plantId);
      print('OrderProvider: Fetched ${_orders.length} orders');
    } catch (e) {
      _errorMessage = 'Failed to fetch orders. Please try again.';
      print('OrderProvider: Error fetching orders: $e');
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  // Complete an order
  Future<bool> completeOrder(String orderId) async {
    try {
      print('OrderProvider: Completing order: $orderId');
      final success = await _orderService.completeOrder(orderId);
      if (success) {
        print('OrderProvider: Order completed, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('OrderProvider: Error completing order: $e');
      return false;
    }
  }

  // Cancel an order
  Future<bool> cancelOrder(String orderId) async {
    try {
      print('OrderProvider: Cancelling order: $orderId');
      final success = await _orderService.cancelOrder(orderId);
      if (success) {
        print('OrderProvider: Order cancelled, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      print('OrderProvider: Error cancelling order: $e');
      return false;
    }
  }

  // Switch tab between Complete and Cancel
  void switchTab(bool isCompleted) {
    _isCompletedTab = isCompleted;
    notifyListeners();
  }
}
