import 'package:flutter/material.dart';
import 'package:tracklet_super_admin/src/models/user_model.dart';
import 'package:tracklet_super_admin/src/models/create_user_response.dart';
import 'package:tracklet_super_admin/src/services/admin_service.dart';

class UsersProvider extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  List<UserModel> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = 'all';
  String _searchQuery = '';

  // Getters
  List<UserModel> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedRole => _selectedRole;
  String get searchQuery => _searchQuery;

  // Filtered users
  List<UserModel> get filteredUsers {
    var filtered = _users;

    // Filter by role
    if (_selectedRole != 'all') {
      filtered = filtered.where((user) => user.role == _selectedRole).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((user) {
        return user.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }

  /// Load users
  Future<void> loadUsers({String? role, String? search}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _adminService.getUsers(role: role, search: search);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load users: $e';
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new user
  Future<CreateUserResponse?> createUser({
    required String name,
    required String role,
    String? password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _adminService.generateUserEmail(
        name: name,
        role: role,
        password: password,
      );

      if (result['success'] == true) {
        _errorMessage = null;
        // Reload users
        await loadUsers();
        _isLoading = false;
        notifyListeners();
        return result['user'] as CreateUserResponse;
      } else {
        _errorMessage = result['message'] as String?;
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Failed to create user: $e';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      final success = await _adminService.deleteUser(userId);
      
      if (success) {
        _users.removeWhere((user) => user.id == userId);
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete user: $e';
      notifyListeners();
      return false;
    }
  }

  /// Reset user password
  Future<String?> resetPassword(String userId, String newPassword) async {
    try {
      final result = await _adminService.resetPassword(userId, newPassword);
      
      if (result['success'] == true) {
        return result['newPassword'] as String;
      }
      
      _errorMessage = result['message'] as String?;
      notifyListeners();
      return null;
    } catch (e) {
      _errorMessage = 'Failed to reset password: $e';
      notifyListeners();
      return null;
    }
  }

  /// Set role filter
  void setRoleFilter(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  /// Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Refresh users
  Future<void> refresh() async {
    await loadUsers();
  }

  /// Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

