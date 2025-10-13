import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/distributor_orders_provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/driver_screen_provider.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// Driver assignment dialog - yeh dialog driver assign krne ke liye hai
class DriverAssignmentDialog extends StatelessWidget {
  final BuildContext parentContext;
  
  const DriverAssignmentDialog({super.key, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DriverScreenProvider, DistributorOrdersProvider>(
      builder: (context, driverProvider, ordersProvider, _) {
        // Get approved orders that need driver assignment
        final approvedOrders = ordersProvider.approvedOrders;

        if (approvedOrders.isEmpty) {
          ScaffoldMessenger.of(parentContext).showSnackBar(
            SnackBar(
              content: Text(AppStrings.noOrdersAvailable),
              backgroundColor: AppColors.warningColor,
            ),
          );
          Navigator.of(context).pop();
          return const SizedBox();
        }

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.assignment, color: AppColors.darkBlue),
              const SizedBox(width: 8),
              Text(AppStrings.assignDriverToOrder),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.selectOrderToAssignDriver,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: approvedOrders.length,
                    itemBuilder: (context, index) {
                      final order = approvedOrders[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.darkBlue,
                            child: Text(
                              order.distributorName.substring(0, 2).toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.onBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            '${AppStrings.order} #${order.id}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(order.plantName),
                              Text('${order.totalKg.toInt()} KG • Rs. ${order.totalPrice.toStringAsFixed(0)}'),
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop(); // Close dialog
                            // We'll handle the driver selection in the parent widget
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppStrings.cancel),
            ),
          ],
        );
      },
    );
  }
}