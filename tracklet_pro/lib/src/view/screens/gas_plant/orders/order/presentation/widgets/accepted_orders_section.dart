import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/provider/order_provider.dart';
import 'package:tracklet_pro/src/ui_components/dashboard/gas_plant_order_card.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

/// Section displaying accepted orders (Orders in Progress)
/// Shows orders with Complete/Cancel buttons
class AcceptedOrdersSection extends StatelessWidget {
  const AcceptedOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        final acceptedOrders = provider.acceptedOrders;

        // Hide section if no accepted orders
        if (acceptedOrders.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              'Orders in Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // Order cards
            ...acceptedOrders.map(
              (order) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GasPlantOrderCard(
                  order: order,
                  onAccept: () => _handleComplete(context, order.id, provider),
                  onReject: () => _handleCancel(context, order.id, provider),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Handle order completion
  Future<void> _handleComplete(
    BuildContext context,
    String? orderId,
    OrderProvider provider,
  ) async {
    if (orderId == null) return;

    try {
      final success = await provider.completeOrder(orderId);
      if (!context.mounted) return;

      if (success) {
        final authProvider = context.read<AuthProvider>();
        await provider.fetchOrders(authProvider.user?.id ?? 'default_plant');
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order completed!')));
      }
    } catch (e) {
      print('Error completing order: $e');
    }
  }

  // Handle order cancellation
  Future<void> _handleCancel(
    BuildContext context,
    String? orderId,
    OrderProvider provider,
  ) async {
    if (orderId == null) return;

    try {
      final success = await provider.cancelOrder(orderId);
      if (!context.mounted) return;

      if (success) {
        final authProvider = context.read<AuthProvider>();
        await provider.fetchOrders(authProvider.user?.id ?? 'default_plant');
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Order cancelled')));
      }
    } catch (e) {
      print('Error cancelling order: $e');
    }
  }
}
