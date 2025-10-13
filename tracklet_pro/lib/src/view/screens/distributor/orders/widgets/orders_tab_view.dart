import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/distributor_orders_provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/orders/widgets/orders_list.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// Orders tab view - yeh screen orders tabs dikhata hai
class OrdersTabView extends StatelessWidget {
  const OrdersTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<DistributorOrdersProvider>(context);
    
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Tabs Section
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.lightBlueBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: AppColors.darkBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              labelColor: AppColors.onBackground,
              unselectedLabelColor: AppColors.disabledTextColor,
              tabs: [
                Tab(text: AppStrings.inProgress),
                Tab(text: AppStrings.completed),
                Tab(text: AppStrings.cancelled),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              children: [
                // In Progress Tab
                OrdersList(orders: ordersProvider.orders),
                // Completed Tab
                Center(
                  child: Text(
                    '${AppStrings.completed} ${AppStrings.orders}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                // Cancelled Tab
                Center(
                  child: Text(
                    '${AppStrings.cancelled} ${AppStrings.orders}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}