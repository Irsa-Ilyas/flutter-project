import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/driver_model.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// Driver details screen - yeh screen driver ki details dikhata hai
class DriverDetailsScreen extends StatelessWidget {
  final DriverModel driver;

  const DriverDetailsScreen({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.lightBlue,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.disabledTextColor,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.driverDetails, // Using AppStrings
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge, // Using AppTheme text styles
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Driver info and contact icons
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: AppColors.darkBlue,
                    child: Text(
                      driver.name.substring(0, 2).toUpperCase(),
                      style: const TextStyle(color: AppColors.onBackground),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge, // Using AppTheme text styles
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0321 1112235',
                          style: TextStyle(color: AppColors.disabledTextColor),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.phone,
                      color: AppColors.disabledTextColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.copy,
                      color: AppColors.disabledTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Toggle buttons for 'In progress' and 'Completed'
              _DriverOrdersToggle(),
              const SizedBox(height: 16),
              // Orders list
              const Expanded(child: _OrdersList()),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // 'Drivers' tab selected
        selectedItemColor: AppColors.onBackground,
        unselectedItemColor: AppColors.disabledTextColor,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list_alt_outlined),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping_outlined),
            label: AppStrings.drivers,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            label: AppStrings.settings,
          ),
        ],
      ),
    );
  }
}

// Driver orders toggle - yeh widget orders toggle dikhata hai
class _DriverOrdersToggle extends StatelessWidget {
  const _DriverOrdersToggle();

  @override
  Widget build(BuildContext context) {
    // Simple toggle without state - just for UI
    // In real app, this would connect to a provider to filter orders
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              // TODO: Connect to provider to show in-progress orders
              print('Show in-progress orders');
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.onBackground,
              side: const BorderSide(color: AppColors.darkBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              AppStrings.inProgress,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.disabledTextColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Connect to provider to show completed orders
              print('Show completed orders');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              AppStrings.completed,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Orders list - yeh widget orders ki list dikhata hai
class _OrdersList extends StatelessWidget {
  const _OrdersList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return const OrderCard();
      },
    );
  }
}

// Order card - yeh widget order card dikhata hai
class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.gasPlantName,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium, // Using AppTheme text styles
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.successColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  AppStrings.completed,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Time and Date row
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 16,
                color: AppColors.disabledTextColor,
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.orderTime,
                style: TextStyle(color: AppColors.disabledTextColor),
              ),
              const SizedBox(width: 16),
              const Icon(
                Icons.event,
                size: 16,
                color: AppColors.disabledTextColor,
              ),
              const SizedBox(width: 4),
              Text(
                AppStrings.orderDate,
                style: TextStyle(color: AppColors.disabledTextColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Driver name
          RichText(
            text: TextSpan(
              style: TextStyle(color: AppColors.onBackground),
              children: [
                TextSpan(
                  text: '${AppStrings.driverName}: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: 'Romail Ahmed'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Special instructions
          RichText(
            text: TextSpan(
              style: TextStyle(color: AppColors.onBackground),
              children: [
                TextSpan(
                  text: '${AppStrings.specialInstructions}:\n',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text:
                      'Please deliver after 2 PM. Handle cylinders carefully.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Location
          RichText(
            text: TextSpan(
              style: TextStyle(color: AppColors.onBackground),
              children: [
                TextSpan(
                  text: '${AppStrings.location}:\n',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: 'Plot #45, Industrial Area, Lahore, Pakistan',
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Requested items
          Text(
            AppStrings.requestedItems,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          Wrap(
            spacing: 6,
            children: [
              Chip(
                label: const Text('45.4 KG (3)'),
                backgroundColor: AppColors.disabledTextColor,
                labelStyle: const TextStyle(color: AppColors.onBackground),
              ),
              Chip(
                label: const Text('15 KG (5)'),
                backgroundColor: AppColors.disabledTextColor,
                labelStyle: const TextStyle(color: AppColors.onBackground),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Total Kg row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.totalKg,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Text(
                '225 KG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
