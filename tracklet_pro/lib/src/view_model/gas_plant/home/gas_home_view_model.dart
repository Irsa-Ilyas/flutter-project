import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/index.dart';

/// View Model for Gas Plant Home/Dashboard
/// Handles data operations and business logic
class GasHomeViewModel extends ChangeNotifier {
  // User information
  final String _userName = "Bilal Ahmed";
  String get userName => _userName;

  // Dashboard tabs data (static)
  final List<DashboardTab> _tabs = [
    DashboardTab(
      title: "Total Stock",
      value: "12.5 Tons",
      icon: Icons.inventory,
    ),
    DashboardTab(title: "Active Employees", value: "20", icon: Icons.person),
    DashboardTab(
      title: "Orders in Progress",
      value: "07",
      icon: Icons.receipt_long,
    ),
  ];
  List<DashboardTab> get tabs => _tabs;

  // Employee data
  final List<Map<String, String>> _employees = [
    {
      'name': 'Ahmed Khan',
      'position': 'Delivery Driver',
      'status': 'Active',
      'imageUrl': 'https://randomuser.me/api/portraits/men/2.jpg',
    },
    {
      'name': 'Sana Ali',
      'position': 'Warehouse Manager',
      'status': 'Active',
      'imageUrl': 'https://randomuser.me/api/portraits/women/3.jpg',
    },
    {
      'name': 'Usman Siddiqui',
      'position': 'Supervisor',
      'status': 'On Leave',
      'imageUrl': 'https://randomuser.me/api/portraits/men/4.jpg',
    },
  ];
  List<Map<String, String>> get employees => _employees;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load dashboard data from API
  Future<List<DashboardSummary>> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));

      final summaryData = [
        DashboardSummary(
          title: "Total Stock",
          value: "12.5",
          unit: "Tons",
          iconPath: "lib/src/assets/svg/inventory.svg",
          color: const Color(0xFF002455),
          description: "Available",
        ),
        DashboardSummary(
          title: "Active",
          value: "20",
          unit: "Employees",
          iconPath: "lib/src/assets/svg/profile.svg",
          color: const Color(0xFF1A3D7C),
          description: "Workers",
        ),
        DashboardSummary(
          title: "Orders",
          value: "07",
          unit: "Pending",
          iconPath: "lib/src/assets/svg/receipt.svg",
          color: const Color(0xFF1A3D7C),
          description: "in Progress",
        ),
      ];

      return summaryData;
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
