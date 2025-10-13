import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/driver_screen_provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/distributor_orders_provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/drivers/widgets/driver_card.dart';
import 'package:tracklet_pro/src/view/screens/distributor/drivers/dialogs/driver_assignment_dialog.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/shared_widgets/index.dart';

// Driver screen content - yeh screen driver screen ka content dikhata hai
class DriverScreenContent extends StatelessWidget {
  const DriverScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    final driverProvider = Provider.of<DriverScreenProvider>(context);
    final ordersProvider = Provider.of<DistributorOrdersProvider>(context);
    
    // Loading state
    if (driverProvider.isLoading && driverProvider.drivers.isEmpty) {
      return Scaffold(
        body: const Center(child: CustomLoaderWidget()),
      );
    }

    // Error state
    if (driverProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: ${driverProvider.error}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: driverProvider.loadDrivers,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  foregroundColor: AppColors.onBackground,
                ),
                child: Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    // Main content
    final drivers = driverProvider.filteredDrivers;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.distributorDrivers, style: Theme.of(context).textTheme.headlineSmall),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _showAssignmentDialog(context, ordersProvider),
                      icon: const Icon(Icons.assignment),
                      label: Text(AppStrings.assign),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkBlue,
                        foregroundColor: AppColors.onBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                      },
                      icon: const Icon(Icons.add),
                      label: Text(AppStrings.add),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.successColor,
                        foregroundColor: AppColors.onBackground,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search bar
            Container(
              decoration: BoxDecoration(color: AppColors.lightBlueBackground, borderRadius: BorderRadius.circular(8)),
              child: CustomTextFieldWidget(
                controller: driverProvider.searchController,
                hint: AppStrings.searchDrivers,
                onChanged: (_) {},
                suffixIcon: const Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            // Driver list
            Expanded(
              child: drivers.isEmpty
                  ? Center(
                      child: Text(
                        driverProvider.searchQuery.isEmpty ? AppStrings.noDriversFound : AppStrings.noDriversMatchSearch,
                        style: TextStyle(color: AppColors.disabledTextColor, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: drivers.length,
                      itemBuilder: (context, index) {
                        final driver = drivers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: DriverCard(
                            driver: driver,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Show assignment dialog - yeh dialog show krta hai
  void _showAssignmentDialog(BuildContext context, DistributorOrdersProvider ordersProvider) {
    if (ordersProvider.approvedOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppStrings.noOrdersAvailable),
          backgroundColor: AppColors.warningColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => DriverAssignmentDialog(parentContext: context),
    );
  }
}