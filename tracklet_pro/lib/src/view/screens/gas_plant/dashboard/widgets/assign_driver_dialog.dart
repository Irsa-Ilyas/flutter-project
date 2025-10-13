import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/service/driver_service.dart';
import 'package:tracklet_pro/src/model/employee_model.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/providers/notification_provider.dart';
import 'package:tracklet_pro/src/model/notification_model.dart';

class AssignDriverDialog extends StatefulWidget {
  final String orderId;
  final String plantId;
  final String plantName;

  const AssignDriverDialog({
    super.key,
    required this.orderId,
    required this.plantId,
    required this.plantName,
  });

  @override
  State<AssignDriverDialog> createState() => _AssignDriverDialogState();
}

class _AssignDriverDialogState extends State<AssignDriverDialog> {
  final _searchController = TextEditingController();
  final DriverService _driverService = DriverService();

  List<EmployeeModel> _drivers = [];
  bool _isLoading = false;
  bool _isAssigning = false;
  EmployeeModel? _selectedDriver;

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load drivers
  Future<void> _loadDrivers() async {
    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final employerId = authProvider.user?.id ?? '';

      final drivers = await _driverService.searchDrivers(
        search: _searchController.text.trim(),
        employerId: employerId,
      );

      if (mounted) {
        setState(() {
          _drivers = drivers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        CustomFlushbar.showError(context, message: 'Failed to load drivers');
      }
    }
  }

  // Assign driver
  Future<void> _assignDriver() async {
    if (_selectedDriver == null) {
      CustomFlushbar.showError(context, message: 'Please select a driver');
      return;
    }

    setState(() => _isAssigning = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final notificationProvider = context.read<NotificationProvider>();

      final currentUser = authProvider.user;
      if (currentUser == null) {
        CustomFlushbar.showError(context, message: 'User not logged in');
        return;
      }

      // Send notification to Gas Plant about driver assignment
      final success = await notificationProvider.sendNotification(
        senderId: currentUser.id,
        senderName: currentUser.name,
        receiverId: widget.plantId,
        message:
            'Driver ${_selectedDriver!.name} has been assigned for your order',
        type: NotificationType.driverAssigned,
        orderId: widget.orderId,
        driverId: _selectedDriver!.id ?? '',
        driverName: _selectedDriver!.name,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(_selectedDriver);
        CustomFlushbar.showSuccess(
          context,
          message: 'Driver assigned successfully',
        );
      } else {
        CustomFlushbar.showError(context, message: 'Failed to assign driver');
      }
    } catch (e) {
      if (!mounted) return;
      CustomFlushbar.showError(context, message: 'Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isAssigning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              children: [
                const Icon(Icons.local_shipping, color: AppColors.darkBlue),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Assign Driver',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search driver by name or vehicle...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
              ),
              onChanged: (value) {
                // Debounce search
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _loadDrivers();
                  }
                });
              },
            ),
            const SizedBox(height: 16),

            // Drivers List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _drivers.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      itemCount: _drivers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final driver = _drivers[index];
                        final isSelected = _selectedDriver?.id == driver.id;

                        return _buildDriverTile(driver, isSelected);
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // Assign Button
            CustomButtonWidget(
              text: 'Assign Driver',
              type: ButtonType.full,
              isLoading: _isAssigning,
              onPressed: _isAssigning || _selectedDriver == null
                  ? () {}
                  : _assignDriver,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverTile(EmployeeModel driver, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedDriver = driver);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.darkBlue.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.darkBlue : AppColors.lightBlue,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.darkBlue,
              child: Text(
                driver.initials,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    driver.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    driver.phoneNumber,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (driver.vehicleNumber.isNotEmpty)
                    Text(
                      'Vehicle: ${driver.vehicleNumber}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.darkBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No drivers found',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
