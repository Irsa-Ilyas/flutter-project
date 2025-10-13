import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/index.dart';

import 'widgets/orders_tab_view.dart';

// Distributor orders screen - yeh screen distributor ke orders dikhata hai
class DistributorOrdersScreen extends StatelessWidget {
  const DistributorOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: Column(
        children: [
          // Header Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppStrings.orders} ${AppStrings.history}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                Text(
                  '${AppStrings.download} ${AppStrings.report}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.darkBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Orders tab view
          const Expanded(child: OrdersTabView()),
        ],
      ),
    );
  }
}