import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/order_model.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// Order card - yeh screen order card dikhata hai
class OrderCard extends StatelessWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Plant name and time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.plantName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppStrings.orderTime,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onBackground,
                      ),
                    ),
                    Text(
                      AppStrings.orderDate,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.disabledTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Driver Name
            Text(
              '${AppStrings.driverName}: Romail Ahmed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.disabledTextColor,
              ),
            ),
            const SizedBox(height: 12),

            // Special Instructions
            Text(
              AppStrings.specialInstructions,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Please deliver after 2 PM. Handle cylinders carefully.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),

            // Location
            Text(
              AppStrings.location,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Plot #45, Industrial Area, Lahore, Pakistan',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),

            // Requested Items
            Text(
              AppStrings.requestedItems,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.totalKg,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.disabledTextColor,
                  ),
                ),
                Text(
                  '${order.totalKg.toInt()} KG',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}