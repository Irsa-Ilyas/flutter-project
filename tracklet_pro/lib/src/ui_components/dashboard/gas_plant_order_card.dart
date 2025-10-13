import 'package:flutter/material.dart';
// Replaced widget/index.dart with specific imports
import 'package:tracklet_pro/src/widget/custom_text.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
// Replaced utils/index.dart with specific imports
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/model/order.dart';
import 'package:tracklet_pro/src/utils_widgets/network_image_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class GasPlantOrderCard extends StatelessWidget {
  final Order order;
  final bool isNew;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const GasPlantOrderCard({
    super.key,
    required this.order,
    this.isNew = false,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    // Check if this is a completed order
    final isCompleted = order.status?.toLowerCase() == 'completed';

    // Format date and time
    final formattedTime = _formatTime(order.dateTime); // Format: 03:45 PM
    final formattedDate = _formatDate(order.dateTime); // Format: 08-Oct-2025

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.disabledTextColor),
        color: AppColors.onBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: HeadingText(
                              order.traderName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isCompleted) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "Completed",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      BodyText(
                        order.instructions,
                        style: TextStyle(color: AppColors.disabledTextColor),
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Time Section
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedTime,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 16,
                          ), // Space between time and date
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_month,
                                size: 18,
                                color: Colors.blue[900],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[900],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(order.profileImageUrl),
                  child: NetworkImageWidget(
                    imageUrl: order.profileImageUrl,
                    width: 40,
                    height: 40,
                    errorWidget: Icon(
                      Icons.person,
                      size: 20,
                      color: AppColors.disabledTextColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Special Instructions:"),
            Text(
              order.specialInstructions.isEmpty
                  ? "No special instructions"
                  : order.specialInstructions,
            ),
            const SizedBox(height: 8),
            const Text("Requested Items:"),
            Row(
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: order.items
                          .map(
                            (item) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.darkBlue.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${item.weight}kg x ${item.quantity}',
                                style: const TextStyle(
                                  color: AppColors.darkBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(), // Fixed: removed semicolon
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 12),
            // Show different buttons based on order status
            if (order.status?.toLowerCase() == 'pending' ||
                order.status == null) ...[
              // NEW ORDERS: Show Accept/Reject buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      type: ButtonType.small,
                      text: 'Accept',
                      onPressed: onAccept,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButtonWidget(
                      type: ButtonType.small,
                      text: 'Reject',
                      onPressed: onReject,
                      backgroundColor: AppColors.error,
                    ),
                  ),
                ],
              ),
            ] else if (order.status?.toLowerCase() == 'accepted') ...[
              // ACCEPTED ORDERS: Show Complete/Cancel buttons (for Orders screen)
              Row(
                children: [
                  Expanded(
                    child: CustomButtonWidget(
                      type: ButtonType.small,
                      text: 'Complete',
                      onPressed: onAccept,
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButtonWidget(
                      type: ButtonType.small,
                      text: 'Cancel',
                      onPressed: onReject,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ] else if (order.status?.toLowerCase() == 'completed') ...[
              // COMPLETED ORDERS: Show success badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomSvgIcon(
                      assetName: AppIcons.svgCheck,
                      width: 16,
                      height: 16,
                      color: Colors.green,
                      fallbackIcon: AppIcons.checkCircle,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Order Successfully Completed",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (order.status?.toLowerCase() == 'cancelled') ...[
              // CANCELLED ORDERS: Show cancelled badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.block, size: 16, color: Colors.orange),
                    SizedBox(width: 8),
                    Text(
                      "Order Cancelled",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (order.status?.toLowerCase() == 'rejected') ...[
              // REJECTED ORDERS: Show rejected badge
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      "Order Rejected",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper methods for formatting DateTime
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}";
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${dateTime.day.toString().padLeft(2, '0')}-${months[dateTime.month - 1]}-${dateTime.year}";
  }
}
