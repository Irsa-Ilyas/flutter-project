import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/widgets/requested_item.dart';
import 'package:tracklet_pro/src/shared_widgets/order_status_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_chip_widget.dart';
import 'package:tracklet_pro/src/model/order.dart' as model;
import 'package:tracklet_pro/src/utils/index.dart';

class OrderCard extends StatelessWidget {
  final String plantName;
  final String driverName;
  final String instructions;
  final List<RequestedItem> requestedItems;
  final int totalKg;
  final OrderStatus status;

  const OrderCard({
    super.key,
    required this.plantName,
    required this.driverName,
    required this.instructions,
    required this.requestedItems,
    required this.totalKg,
    required this.status,
  });

  // Factory constructor for creating from API data
  factory OrderCard.fromOrderModel(model.Order order) {
    return OrderCard(
      plantName: order.traderName,
      driverName: order.driverName ?? 'Unknown Driver',
      instructions: order.specialInstructions,
      requestedItems: order.items
          .map((item) => RequestedItem.fromModel(item))
          .toList(),
      totalKg: order.totalKg.toInt(),
      status: OrderStatusExtension.fromString(order.status ?? 'In Progress'),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = status == OrderStatus.inProgress
        ? const Color(0xffF1D77F)
        : const Color(0xff4CAF50);

    String statusText = status.name;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  plantName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${AppStrings.driverName}: $driverName',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          if (instructions.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              AppStrings.specialInstructions,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            Text(
              instructions,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.disabledTextColor,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.requestedItems,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Wrap(
                spacing: 2,
                children: requestedItems.map((item) {
                  return CustomChipWidget(
                    label: '${item.weight} KG (${item.quantity})',
                  );
                }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.totalKg,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$totalKg KG',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Convert to order model
  model.Order toOrderModel() {
    return model.Order(
      traderName: plantName,
      profileImageUrl: '',
      dateTime: DateTime.now(),
      instructions: instructions,
      items: requestedItems.map((item) => item.toModel()).toList(),
      totalKg: totalKg.toDouble(),
      driverName: driverName,
      status: status.name,
      specialInstructions: instructions,
      mentioncylinders: '',
    );
  }
}
