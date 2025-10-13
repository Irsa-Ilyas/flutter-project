import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/provider/order_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/completed_tab_button.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/cancelled_tab_button.dart';

class OrdersTabs extends StatelessWidget {
  static const double _tabSpacing = 10.0;
  
  const OrdersTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<OrderProvider, bool>(
      selector: (_, provider) => provider.isCompletedTab,
      builder: (context, isCompletedTab, _) {
        return Row(
          children: [
            CompletedTabButton(
              isActive: isCompletedTab,
              onTap: () => _handleTabChange(context, true),
            ),
            const SizedBox(width: _tabSpacing),
            CancelledTabButton(
              isActive: !isCompletedTab,
              onTap: () => _handleTabChange(context, false),
            ),
          ],
        );
      },
    );
  }

  void _handleTabChange(BuildContext context, bool isCompleted) {
    final provider = Provider.of<OrderProvider>(context, listen: false);
    provider.switchTab(isCompleted);
  }
}