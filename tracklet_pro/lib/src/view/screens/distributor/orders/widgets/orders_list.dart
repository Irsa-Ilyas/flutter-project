import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/order_model.dart';
import 'package:tracklet_pro/src/view/screens/distributor/orders/widgets/order_card.dart';

// Orders list - yeh screen orders ki list dikhata hai
class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('No orders found'),
      );
    }
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        OrderCard(order: orders[0]),
        const SizedBox(height: 16),
        if (orders.length > 1) OrderCard(order: orders[1]), // Second card for demo
      ],
    );
  }
}