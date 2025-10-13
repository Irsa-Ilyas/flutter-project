import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/model/employee_model.dart';

class EmployeeCardWidget extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeCardWidget({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.onBackground,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.lightBlue.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Employee image or placeholder
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.lightBlueBackground,
            child: Icon(
              Icons.person,
              color: AppColors.disabledTextColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Employee info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  employee.role,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.disabledTextColor,
                  ),
                ),
              ],
            ),
          ),
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(employee.status),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              employee.status,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.onBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return AppColors.successColor;
      case 'absent':
        return AppColors.error;
      case 'late':
        return AppColors.warningColor;
      default:
        return AppColors.disabledTextColor;
    }
  }
}
