import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/provider/order_provider.dart';
import 'package:tracklet_pro/src/ui_components/dashboard/gas_plant_order_card.dart';

/// Section displaying completed/cancelled orders based on selected tab
/// Shows read-only order cards
class OrderListSection extends StatelessWidget {
  const OrderListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<OrderProvider>(
        builder: (context, provider, _) {
          // Show loading indicator
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = provider.orders;

          // Show empty state
          if (orders.isEmpty) {
            return _buildEmptyState(context, provider.isCompletedTab);
          }

          // Show order list
          return ListView.separated(
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return GasPlantOrderCard(
                order: orders[index],
                onAccept: () {}, // No action for completed/cancelled orders
                onReject: () {}, // No action for completed/cancelled orders
              );
            },
          );
        },
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState(BuildContext context, bool isCompletedTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCompletedTab ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            isCompletedTab ? 'No completed orders' : 'No cancelled orders',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
