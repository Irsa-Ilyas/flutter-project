import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/order.dart';
import 'package:tracklet_pro/src/service/order_service.dart';

/// View Model for Gas Plant Orders
/// Handles network operations and business logic for orders
class OrderViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  /// Fetch orders for a specific gas plant
  Future<List<Order>> fetchOrders(String plantId) async {
    try {
      return await _orderService.getPlantOrders(plantId);
    } catch (e) {
      debugPrint('OrderViewModel: Error fetching orders: $e');
      return [];
    }
  }

  /// Accept an order
  Future<bool> acceptOrder(String orderId, {String? driverName}) async {
    debugPrint('OrderViewModel: Accepting order: $orderId');
    try {
      return await _orderService.acceptOrder(orderId, driverName: driverName);
    } catch (e) {
      debugPrint('OrderViewModel: Error accepting order: $e');
      return false;
    }
  }

  /// Reject an order
  Future<bool> rejectOrder(String orderId) async {
    debugPrint('OrderViewModel: Rejecting order: $orderId');
    try {
      return await _orderService.rejectOrder(orderId);
    } catch (e) {
      debugPrint('OrderViewModel: Error rejecting order: $e');
      return false;
    }
  }

  /// Complete an order
  Future<bool> completeOrder(String orderId) async {
    debugPrint('OrderViewModel: Completing order: $orderId');
    try {
      return await _orderService.completeOrder(orderId);
    } catch (e) {
      debugPrint('OrderViewModel: Error completing order: $e');
      return false;
    }
  }

  /// Cancel an order
  Future<bool> cancelOrder(String orderId) async {
    debugPrint('OrderViewModel: Cancelling order: $orderId');
    try {
      return await _orderService.cancelOrder(orderId);
    } catch (e) {
      debugPrint('OrderViewModel: Error cancelling order: $e');
      return false;
    }
  }
}
