import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/driver_model.dart';
import 'package:tracklet_pro/src/view/screens/distributor/drivers/screens/driver_details_screen.dart';
import 'package:tracklet_pro/src/utils/index.dart';

// Driver card widget - yeh driver card dikhata hai
class DriverCard extends StatelessWidget {
  final DriverModel driver;

  const DriverCard({
    super.key,
    required this.driver,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to driver details screen when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DriverDetailsScreen(driver: driver),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Avatar
              if (driver.showAvatar)
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.darkBlue,
                  child: Text(
                    driver.name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.onBackground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (driver.showAvatar)
                const SizedBox(width: 16),
              
              // Driver info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            driver.name,
                            style: Theme.of(context).textTheme.titleMedium, // Using AppTheme text styles
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(driver.status),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            driver.status,
                            style: const TextStyle(
                              color: AppColors.onBackground,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      driver.description,
                      style: TextStyle(
                        color: AppColors.disabledTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get status color based on status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return AppColors.successColor;
      case 'on delivery':
        return AppColors.warningColor;
      case 'offline':
        return AppColors.disabledTextColor;
      default:
        return AppColors.disabledTextColor;
    }
  }
}