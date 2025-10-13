import 'package:tracklet_pro/src/model/order.dart';
import 'package:tracklet_pro/src/model/requested_item.dart';

class OrderDummy {
  static List<Order> completedOrders = [
    Order(
      traderName: "Arham Traders",
      profileImageUrl: "",
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      instructions: "",
      items: [
        RequestedItem(weight: 45.4, quantity: 3),
        RequestedItem(weight: 15, quantity: 5),
      ],
      totalKg: 225,
      status: "Completed",
      specialInstructions: "",
      mentioncylinders: "",
    ),
    Order(
      traderName: "Arham Traders",
      profileImageUrl: "",
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      instructions: "",
      items: [
        RequestedItem(weight: 45.4, quantity: 3),
        RequestedItem(weight: 15, quantity: 5),
      ],
      totalKg: 225,
      status: "Completed",
      specialInstructions: "",
      mentioncylinders: "",
    ),
  ];

  static List<Order> cancelledOrders = [];
}
