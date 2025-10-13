import 'package:flutter/material.dart';
import 'package:tracklet_super_admin/src/models/super_admin.dart';
import 'package:tracklet_super_admin/src/services/admin_service.dart';

class AuthProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  SuperAdmin? _admin;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  SuperAdmin? get admin => _admin;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _admin != null && _token != null;

  /// Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _adminService.login(email, password);

      if (result['success'] == true) {
        _admin = result['admin'] as SuperAdmin;
        _token = result['token'] as String;
        _errorMessage = null;
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'] as String?;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  void logout() {
    _admin = null;
    _token = null;
    _errorMessage = null;
    _adminService.logout();
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

