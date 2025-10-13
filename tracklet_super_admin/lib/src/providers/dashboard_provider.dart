import 'package:flutter/material.dart';
import 'package:tracklet_super_admin/src/models/dashboard_stats.dart';
import 'package:tracklet_super_admin/src/services/admin_service.dart';

class DashboardProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  DashboardStats? _stats;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  DashboardStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load dashboard statistics
  Future<void> loadStats() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _stats = await _adminService.getStats();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load statistics: $e';
      _stats = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh stats
  Future<void> refresh() async {
    await loadStats();
  }
}

