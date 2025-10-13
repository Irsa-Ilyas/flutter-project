import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/screens/order_history_screen.dart';

class GasPlantOrdersScreen extends StatelessWidget {
  const GasPlantOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // OrderProvider is already available globally from app_providers.dart
    return const OrderHistoryScreen();
  }
}
