import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/order_model.dart';

/// View Model for Distributor Orders
/// Handles network operations and business logic for distributor orders
class DistributorOrderViewModel extends ChangeNotifier {
  // Mock data - in real app this would come from API
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'ORD-001',
      distributorName: 'Al-Rehman Distributors',
      plantName: 'City Gas Plant',
      totalKg: 150.0,
      totalPrice: 37500.0,
      status: 'Approved',
    ),
    OrderModel(
      id: 'ORD-002',
      distributorName: 'Hashim Traders',
      plantName: 'National Gas Plant',
      totalKg: 90.0,
      totalPrice: 22500.0,
      status: 'Approved',
    ),
    OrderModel(
      id: 'ORD-003',
      distributorName: 'Khan Enterprises',
      plantName: 'Premium Gas Plant',
      totalKg: 200.0,
      totalPrice: 50000.0,
      status: 'Pending',
    ),
  ];

  /// Load orders for a distributor
  Future<List<OrderModel>> loadOrders() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return List.from(_mockOrders);
      // In real implementation:
      // return await OrderService().getDistributorOrders(distributorId);
    } catch (e) {
      debugPrint('DistributorOrderViewModel: Error loading orders: $e');
      return [];
    }
  }

  /// Assign driver to order
  Future<bool> assignDriver(String orderId, String driverId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return true;
      // In real implementation:
      // return await OrderService().assignDriver(orderId, driverId);
    } catch (e) {
      debugPrint('DistributorOrderViewModel: Error assigning driver: $e');
      return false;
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String status) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      return true;
      // In real implementation:
      // return await OrderService().updateOrderStatus(orderId, status);
    } catch (e) {
      debugPrint('DistributorOrderViewModel: Error updating status: $e');
      return false;
    }
  }
}
