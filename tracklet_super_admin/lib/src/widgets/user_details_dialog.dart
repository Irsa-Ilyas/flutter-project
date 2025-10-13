import 'package:flutter/material.dart';
import 'package:tracklet_super_admin/src/models/user_model.dart';
import 'package:tracklet_super_admin/src/utils/app_colors.dart';
import 'package:intl/intl.dart';

class UserDetailsDialog extends StatelessWidget {
  final UserModel user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImageUrl),
                backgroundColor: user.role == 'gas_plant'
                    ? AppColors.gasPlantColor.withValues(alpha: 0.1)
                    : AppColors.distributorColor.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 16),

              // Name
              Text(
                user.name,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Role Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: user.role == 'gas_plant'
                      ? AppColors.gasPlantColor.withValues(alpha: 0.1)
                      : AppColors.distributorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  user.roleDisplayName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: user.role == 'gas_plant'
                        ? AppColors.gasPlantColor
                        : AppColors.distributorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Details
              _DetailRow(icon: Icons.email, label: 'Email', value: user.email),
              if (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
                _DetailRow(
                  icon: Icons.phone,
                  label: 'Phone',
                  value: user.phoneNumber!,
                ),
              if (user.address != null && user.address!.isNotEmpty)
                _DetailRow(
                  icon: Icons.location_on,
                  label: 'Address',
                  value: user.address!,
                ),
              if (user.plantId != null)
                _DetailRow(
                  icon: Icons.factory,
                  label: 'Plant ID',
                  value: user.plantId!,
                  valueColor: AppColors.info,
                ),
              if (user.plantName != null)
                _DetailRow(
                  icon: Icons.business,
                  label: 'Plant Name',
                  value: user.plantName!,
                ),
              _DetailRow(
                icon: Icons.calendar_today,
                label: 'Created',
                value: DateFormat('MMM dd, yyyy').format(user.createdAt),
              ),

              const SizedBox(height: 24),

              // Close Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
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
