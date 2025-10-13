import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/index.dart';

/// Provider for Gas Plant Home/Dashboard
/// Handles state management for dashboard UI
class GasHomeProvider extends ChangeNotifier {
  // Selected tab index
  int _selectedTabIndex = -1;
  int get selectedTabIndex => _selectedTabIndex;

  // Dashboard summary data
  List<DashboardSummary> _summaryData = [];
  List<DashboardSummary> get summaryData => _summaryData;

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

  // Method to update summary data from view model
  void updateSummaryData(List<DashboardSummary> data) {
    _summaryData = data;
    notifyListeners();
  }
}
