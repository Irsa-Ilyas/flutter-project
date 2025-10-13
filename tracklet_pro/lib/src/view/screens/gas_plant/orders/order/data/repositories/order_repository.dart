import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/data/model/order_model.dart';
import 'package:tracklet_pro/src/service/order_service.dart';

class OrderRepository {
  final OrderService _orderService = OrderService();

  // Get all orders for a plant
  Future<List<OrderModel>> getPlantOrders(String plantId) async {
    try {
      final orders = await _orderService.getPlantOrders(plantId);

      // Convert Order objects to OrderModel objects
      return orders.map((order) {
        return OrderModel(
          traderName: order.traderName,
          requestedItems: order.items
              .map((item) => '${item.weight}kg x ${item.quantity}')
              .toList(),
          totalKg: order.totalKg.toInt(),
          totalBill: (order.totalKg * 250)
              .toDouble(), // Assuming 250 PKR per kg
          status: order.status ?? 'pending',
          specialInstruction: order.specialInstructions,
          location: 'Default Location',
          driverName: order.driverName,
          createdAt: order.dateTime,
        );
      }).toList();
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      // For now, we'll just return an empty list to indicate failure
      return [];
    }
  }

  // Accept an order
  Future<bool> acceptOrder(String orderId, {String? driverName}) async {
    try {
      return await _orderService.acceptOrder(orderId, driverName: driverName);
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      // For now, we'll just return false to indicate failure
      return false;
    }
  }

  // Reject an order
  Future<bool> rejectOrder(String orderId) async {
    try {
      return await _orderService.rejectOrder(orderId);
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      // For now, we'll just return false to indicate failure
      return false;
    }
  }
}
