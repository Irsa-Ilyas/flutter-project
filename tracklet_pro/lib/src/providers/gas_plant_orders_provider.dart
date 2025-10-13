import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/order.dart';
import 'package:tracklet_pro/src/service/order_service.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class GasPlantOrdersProvider extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  // Get orders by status for UI sections (following existing UI flow)
  List<Order> get newOrders => _orders
      .where(
        (order) =>
            order.status == null || order.status?.toLowerCase() == 'pending',
      )
      .toList();

  // Previous orders = accepted orders (shown on dashboard)
  List<Order> get previousOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'accepted')
      .toList();

  // Completed orders (for Orders screen Complete tab)
  List<Order> get completedOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'completed')
      .toList();

  // Cancelled orders (for Orders screen Cancel tab)
  List<Order> get cancelledOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'cancelled')
      .toList();

  // Rejected orders
  List<Order> get rejectedOrders => _orders
      .where((order) => order.status?.toLowerCase() == 'rejected')
      .toList();

  // Fetch orders from backend
  Future<void> fetchOrders(String plantId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await _orderService.getPlantOrders(plantId);
    } catch (e) {
      Logger.error('GasPlantOrdersProvider: Error fetching orders: $e');
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Accept order - moves to "In Progress"
  Future<bool> acceptOrder(String orderId, {String? driverName}) async {
    Logger.debug('GasPlantOrdersProvider: Accepting order: $orderId');
    try {
      final success = await _orderService.acceptOrder(
        orderId,
        driverName: driverName,
      );
      if (success) {
        Logger.debug('GasPlantOrdersProvider: Order accepted, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      Logger.error('GasPlantOrdersProvider: Error accepting order: $e');
      return false;
    }
  }

  // Reject order - moves to "Rejected"
  Future<bool> rejectOrder(String orderId) async {
    Logger.debug('GasPlantOrdersProvider: Rejecting order: $orderId');
    try {
      final success = await _orderService.rejectOrder(orderId);
      if (success) {
        Logger.debug('GasPlantOrdersProvider: Order rejected, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      Logger.error('GasPlantOrdersProvider: Error rejecting order: $e');
      return false;
    }
  }

  // Complete order - moves to "Completed"
  Future<bool> completeOrder(String orderId) async {
    Logger.debug('GasPlantOrdersProvider: Completing order: $orderId');
    try {
      final success = await _orderService.completeOrder(orderId);
      if (success) {
        Logger.debug('GasPlantOrdersProvider: Order completed, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      Logger.error('GasPlantOrdersProvider: Error completing order: $e');
      return false;
    }
  }

  // Cancel order - moves to "Cancelled"
  Future<bool> cancelOrder(String orderId) async {
    Logger.debug('GasPlantOrdersProvider: Cancelling order: $orderId');
    try {
      final success = await _orderService.cancelOrder(orderId);
      if (success) {
        Logger.debug('GasPlantOrdersProvider: Order cancelled, refreshing...');
        notifyListeners();
      }
      return success;
    } catch (e) {
      Logger.error('GasPlantOrdersProvider: Error cancelling order: $e');
      return false;
    }
  }
}