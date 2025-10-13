import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/order.dart';

class OrderCard extends StatelessWidget {
  static const double _cardPadding = 12.0;
  static const double _spacing = 8.0;
  
  final Order order;
  
  const OrderCard({
    super.key, 
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: _spacing),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, textTheme, scheme),
            const SizedBox(height: _spacing * 1.5),
            _buildRequestedItemsSection(context, textTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, 
    TextTheme textTheme, 
    ColorScheme scheme,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            order.traderName, 
            style: textTheme.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: _spacing),
        _buildStatusChip(textTheme, scheme),
      ],
    );
  }

  Widget _buildStatusChip(TextTheme textTheme, ColorScheme scheme) {
    final status = order.status ?? 'pending';
    return Chip(
      label: Text(_getStatusText(status)),
      backgroundColor: _getStatusColor(scheme, status),
      labelStyle: textTheme.labelSmall?.copyWith(
        color: _getStatusTextColor(status),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildRequestedItemsSection(
    BuildContext context, 
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requested items', 
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: _spacing),
        _buildItemsChips(),
      ],
    );
  }

  Widget _buildItemsChips() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scheme = Theme.of(context).colorScheme;
        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: order.items.map(
            (item) => SizedBox(
              height: 24,
              child: Chip(
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                label: Text(
                  '${item.weight}KG x ${item.quantity}',
                  style: TextStyle(
                    color: scheme.onSecondaryContainer,
                    fontSize: 11,
                  ),
                ),
                backgroundColor: scheme.secondaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide.none,
                ),
              ),
            ),
          ).toList(),
        );
      },
    );
  }





  // Helper methods for status handling
  String _getStatusText(String status) {
    const statusMap = <String, String>{
      'pending': 'Pending',
      'approved': 'Approved',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'rejected': 'Rejected',
    };
    return statusMap[status.toLowerCase()] ?? status;
  }

  Color _getStatusColor(ColorScheme scheme, String status) {
    final statusColor = <String, Color>{
      'pending': Colors.orange.shade100,
      'approved': Colors.blue.shade100,
      'completed': Colors.green.shade100,
      'cancelled': Colors.red.shade100,
      'rejected': Colors.grey.shade100,
    };
    return statusColor[status.toLowerCase()] ?? scheme.primaryContainer;
  }

  Color _getStatusTextColor(String status) {
    final textColor = <String, Color>{
      'pending': Colors.orange.shade800,
      'approved': Colors.blue.shade800,
      'completed': Colors.green.shade800,
      'cancelled': Colors.red.shade800,
      'rejected': Colors.grey.shade800,
    };
    return textColor[status.toLowerCase()] ?? Colors.black87;
  }
}
