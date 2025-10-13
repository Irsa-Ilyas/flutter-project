import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tracklet_super_admin/src/models/super_admin.dart';
import 'package:tracklet_super_admin/src/models/user_model.dart';
import 'package:tracklet_super_admin/src/models/dashboard_stats.dart';
import 'package:tracklet_super_admin/src/models/create_user_response.dart';
import 'package:tracklet_super_admin/src/services/base_service.dart';
import 'package:tracklet_super_admin/src/utils/app_constants.dart';

class AdminService extends BaseService {
  // Singleton pattern
  static final AdminService _instance = AdminService._internal();
  factory AdminService() => _instance;
  AdminService._internal();

  /// Login Super Admin
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        AppConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Store token
        final token = data['token'] as String;
        setAuthToken(token);

        return {
          'success': true,
          'token': token,
          'admin': SuperAdmin.fromJson(data['admin']),
        };
      }

      return {'success': false, 'message': 'Login failed'};
    } on DioException catch (e) {
      debugPrint('AdminService: Login error: $e');

      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Login failed',
        };
      }

      return {'success': false, 'message': 'Network error'};
    } catch (e) {
      print('AdminService: Unexpected error: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  /// Generate new user email
  Future<Map<String, dynamic>> generateUserEmail({
    required String name,
    required String role,
    String? password,
  }) async {
    try {
      final response = await dio.post(
        AppConstants.generateEmailEndpoint,
        data: {
          'name': name,
          'role': role,
          if (password != null && password.isNotEmpty) 'password': password,
        },
      );

      if (response.statusCode == 201) {
        final data = response.data;

        return {
          'success': true,
          'user': CreateUserResponse.fromJson(data['user']),
        };
      }

      return {'success': false, 'message': 'Failed to create user'};
    } on DioException catch (e) {
      debugPrint('AdminService: Generate email error: $e');

      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to create user',
        };
      }

      return {'success': false, 'message': 'Network error'};
    } catch (e) {
      print('AdminService: Unexpected error: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  /// Get all users
  Future<List<UserModel>> getUsers({String? role, String? search}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (role != null && role.isNotEmpty) queryParams['role'] = role;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await dio.get(
        AppConstants.usersEndpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final users = (data['users'] as List)
            .map((user) => UserModel.fromJson(user))
            .toList();

        return users;
      }

      return [];
    } on DioException catch (e) {
      debugPrint('AdminService: Get users error: $e');
      return [];
    } catch (e) {
      debugPrint('AdminService: Unexpected error: $e');
      return [];
    }
  }

  /// Get dashboard statistics
  Future<DashboardStats?> getStats() async {
    try {
      final response = await dio.get(AppConstants.statsEndpoint);

      if (response.statusCode == 200) {
        final data = response.data;
        return DashboardStats.fromJson(data['stats']);
      }

      return null;
    } on DioException catch (e) {
      debugPrint('AdminService: Get stats error: $e');
      return null;
    } catch (e) {
      debugPrint('AdminService: Unexpected error: $e');
      return null;
    }
  }

  /// Delete a user
  Future<bool> deleteUser(String userId) async {
    try {
      final response = await dio.delete(
        '${AppConstants.usersEndpoint}/$userId',
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      debugPrint('AdminService: Delete user error: $e');
      return false;
    } catch (e) {
      debugPrint('AdminService: Unexpected error: $e');
      return false;
    }
  }

  /// Reset user password
  Future<Map<String, dynamic>> resetPassword(
    String userId,
    String newPassword,
  ) async {
    try {
      final response = await dio.put(
        '${AppConstants.usersEndpoint}/$userId/reset-password',
        data: {'newPassword': newPassword},
      );

      if (response.statusCode == 200) {
        return {'success': true, 'newPassword': response.data['newPassword']};
      }

      return {'success': false, 'message': 'Failed to reset password'};
    } on DioException catch (e) {
      debugPrint('AdminService: Reset password error: $e');

      if (e.response != null) {
        return {
          'success': false,
          'message': e.response?.data['message'] ?? 'Failed to reset password',
        };
      }

      return {'success': false, 'message': 'Network error'};
    } catch (e) {
      print('AdminService: Unexpected error: $e');
      return {'success': false, 'message': 'An error occurred'};
    }
  }

  /// Logout
  void logout() {
    clearAuthToken();
  }
}
