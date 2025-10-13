import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/provider/order_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/orders_tabs.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/profile_header.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/accepted_orders_section.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/order_list_section.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

/// Main Order History Screen
/// Shows: Profile Header, Accepted Orders (in progress), Tabs, Order List
class OrderHistoryScreen extends StatefulWidget {
  static const double _defaultPadding = 16.0;
  static const double _spacing = 20.0;

  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  // Load orders from backend
  void _loadOrders() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final authProvider = context.read<AuthProvider>();
        final orderProvider = context.read<OrderProvider>();
        final plantId = authProvider.user?.id ?? 'default_plant';
        orderProvider.fetchOrders(plantId);
      } catch (e) {
        print('Error fetching orders: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(OrderHistoryScreen._defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ProfileHeader(),
              SizedBox(height: OrderHistoryScreen._spacing),
              AcceptedOrdersSection(),
              SizedBox(height: OrderHistoryScreen._spacing),
              OrdersTabs(),
              SizedBox(height: OrderHistoryScreen._spacing),
              OrderListSection(),
            ],
          ),
        ),
      ),
    );
  }
}
