import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/model/index.dart';

class GasPlantDashboardViewModel extends BaseViewModel {
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

  // Dashboard summary data (for API integration)
  List<DashboardSummary> _summaryData = [];
  List<DashboardSummary> get summaryData => _summaryData;

  // Selected tab index
  int _selectedTabIndex = -1;
  int get selectedTabIndex => _selectedTabIndex;

  // New orders data
  final List<Order> _newOrders = [
    Order(
      traderName: "Arham Traders",
      profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
      instructions: "Please deliver after 2 PM. Handle cylinders carefully.",
      specialInstructions:
          "Please deliver after 2 PM. Handle cylinders carefully.",
      dateTime: DateTime(2025, 10, 8, 15, 45),

      items: [
        RequestedItem(weight: 45.4, quantity: 3),
        RequestedItem(weight: 15, quantity: 5),
      ],
      totalKg: 225,
      mentioncylinders:
          "Arham Traders placed a request for mentioned cylinders",
    ),
  ];
  List<Order> get newOrders => _newOrders;

  // Previous orders data
  final List<Order> _previousOrders = [
    Order(
      traderName: "Arham Traders",
      profileImageUrl: "https://randomuser.me/api/portraits/men/1.jpg",
      mentioncylinders:
          "Arham Traders placed a request for mentioned cylinders",
      dateTime: DateTime(2025, 10, 8, 15, 45),
      instructions: "Please deliver after 2 PM. Handle cylinders carefully.",
      items: [
        RequestedItem(weight: 45.4, quantity: 3),
        RequestedItem(weight: 15, quantity: 5),
      ],
      totalKg: 225,
      driverName: "Romail Ahmed",
      status: "Completed",
      specialInstructions:
          'Please deliver after 2 PM. Handle cylinders carefully.',
    ),
  ];
  List<Order> get previousOrders => _previousOrders;

  // Completed orders from in-progress
  final List<Order> _completedOrders = <Order>[];
  List<Order> get completedOrders => _completedOrders;

  // Methods to update data would go here in a real implementation
  // For now, we're just using static data

  // Method to select a tab
  void selectTab(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  // Method to reset tab selection
  void resetTabSelection() {
    _selectedTabIndex = -1;
    notifyListeners();
  }

  // Method to update summary data from API
  void updateSummaryData(List<DashboardSummary> data) {
    _summaryData = data;
    notifyListeners();
  }

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

  // Method to load data from API (placeholder)
  Future<void> loadDashboardData() async {
    // In a real implementation, this would call an API
    // For now, we'll convert the static data to the new format
    _summaryData = [
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
    notifyListeners();
  }

  // Method to add a completed order from in-progress
  void addCompletedOrder(Order order) {
    _completedOrders.add(order);
    notifyListeners();
  }

  // Method to remove an order from new orders (when it's accepted/rejected)
  void removeNewOrder(Order order) {
    _newOrders.remove(order);
    notifyListeners();
  }
}
