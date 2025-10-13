import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/order.dart';
import 'package:tracklet_pro/src/model/requested_item.dart';

class OrderService extends BaseService {
  // Singleton instance
  static final OrderService _instance = OrderService._internal();
  factory OrderService() => _instance;
  OrderService._internal();

  // Submit a new order
  Future<bool> submitOrder({
    required String distributorId,
    required String distributorName,
    required String plantId,
    required String plantName,
    required String plantImageUrl,
    required Map<double, int> quantities,
    required String specialInstructions,
    required int totalKg,
    required int totalPrice,
  }) async {
    try {
      // Create requested items from quantities
      final items = <Map<String, dynamic>>[];
      quantities.forEach((weight, quantity) {
        if (quantity > 0) {
          items.add({'weight': weight, 'quantity': quantity});
        }
      });

      // Create the order object
      final order = {
        'distributorId': distributorId,
        'distributorName': distributorName,
        'plantId': plantId,
        'plantName': plantName,
        'plantImageUrl': plantImageUrl,
        'items': items,
        'specialInstructions': specialInstructions,
        'totalKg': totalKg,
        'totalPrice': totalPrice,
      };

      // Make API call to submit order
      print('OrderService: Submitting order to /api/orders');
      print('OrderService: Order data: $order');
      final response = await dio.post('/api/orders', data: order);
      print('OrderService: Response status code: ${response.statusCode}');
      print('OrderService: Response data: ${response.data}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      print('OrderService: Error submitting order: $e');
      return false;
    }
  }

  // Get orders for a gas plant
  Future<List<Order>> getPlantOrders(String plantId) async {
    try {
      print('OrderService: Getting orders for plant: $plantId');
      final response = await dio.get('/api/orders/plant/$plantId');
      print(
        'OrderService: GET /api/orders/plant/$plantId response status: ${response.statusCode}',
      );
      print('OrderService: Response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data;
        print('OrderService: Found ${ordersData.length} orders');

        final orders = ordersData.map((orderData) {
          final items = (orderData['items'] as List)
              .map(
                (item) => RequestedItem(
                  weight: (item['weight'] as num).toDouble(),
                  quantity: item['quantity'] as int,
                ),
              )
              .toList();

          return Order(
            id: orderData['_id'] as String?, // Include MongoDB ID
            traderName: orderData['distributorName'] as String,
            profileImageUrl: orderData['plantImageUrl'] as String,
            dateTime: DateTime.parse(orderData['createdAt'] as String),
            instructions: orderData['specialInstructions'] as String,
            items: items,
            totalKg: (orderData['totalKg'] as num).toDouble(),
            driverName: orderData['driverName'] as String?,
            status: orderData['status'] as String?,
            specialInstructions: orderData['specialInstructions'] as String,
            mentioncylinders: items
                .map((item) => '${item.weight}kg x ${item.quantity}')
                .join(', '),
          );
        }).toList();

        return orders;
      }

      return [];
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      print('OrderService: ERROR fetching orders: $e');
      return [];
    }
  }

  // Accept an order
  Future<bool> acceptOrder(String orderId, {String? driverName}) async {
    try {
      final data = <String, dynamic>{};
      if (driverName != null) {
        data['driverName'] = driverName;
      }

      print('OrderService: Accepting order: $orderId');
      final response = await dio.put('/api/orders/$orderId/accept', data: data);
      return response.statusCode == 200;
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      // For now, we'll just return false to indicate failure
      return false;
    }
  }

  // Reject an order
  Future<bool> rejectOrder(String orderId) async {
    try {
      print('OrderService: Rejecting order: $orderId');
      final response = await dio.put('/api/orders/$orderId/reject');
      return response.statusCode == 200;
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      // For now, we'll just return false to indicate failure
      return false;
    }
  }

  // Complete an order
  Future<bool> completeOrder(String orderId) async {
    try {
      print('OrderService: Completing order: $orderId');
      final response = await dio.put('/api/orders/$orderId/complete');
      return response.statusCode == 200;
    } catch (e) {
      // In a production app, you would log this to a proper logging service
      print('OrderService: Error completing order: $e');
      return false;
    }
  }

  // Cancel an order
  Future<bool> cancelOrder(String orderId) async {
    try {
      print('OrderService: Cancelling order: $orderId');
      final response = await dio.put('/api/orders/$orderId/cancel');
      return response.statusCode == 200;
    } catch (e) {
      print('OrderService: Error cancelling order: $e');
      return false;
    }
  }
}
