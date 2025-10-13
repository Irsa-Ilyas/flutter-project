import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/user_model.dart';
import 'package:tracklet_pro/src/service/auth_service.dart';
import 'package:tracklet_pro/src/service/profile_service.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();
  UserModel? _user;
  bool _isLoggedIn = false;
  bool _isLoadingProfile = false;
  String? _errorMessage;

  AuthProvider() {
    Logger.debug('AuthProvider: Initialized');
    // Check if user is already logged in (from local storage, etc.)
    // For now, we'll assume user is not logged in
  }

  Future<void> login(String email, String password) async {
    Logger.debug('AuthProvider: Login called with email: $email');
    try {
      Logger.debug('AuthProvider: Calling AuthService.login');
      final user = await _authService.login(email, password);
      Logger.debug('AuthProvider: Login successful, user id: ${user.id}, name: ${user.name}, email: ${user.email}, role: ${user.role}');
      _user = user;
      _isLoggedIn = true;
      Logger.debug('AuthProvider: Setting isLoggedIn to true and updating user state');
      notifyListeners();
      Logger.debug('AuthProvider: Notified listeners about login success');
    } catch (e, stackTrace) {
      Logger.error('AuthProvider: Login failed with error: $e');
      Logger.error('AuthProvider: Login error stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    Logger.debug('AuthProvider: Register called with name: $name, email: $email');
    try {
      final user = await _authService.register(name, email, password);
      Logger.debug('AuthProvider: Registration successful, user role: ${user.role}');
      _user = user;
      _isLoggedIn = true;
      notifyListeners();
      Logger.debug('AuthProvider: Notified listeners about registration success');
    } catch (e) {
      Logger.error('AuthProvider: Registration failed with error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    Logger.debug('AuthProvider: Logout called');
    try {
      // Perform logout operations
      // Clear user data, tokens, etc.
      await _authService.logout();
      _isLoggedIn = false;
      _user = null;
      notifyListeners();
      Logger.debug('AuthProvider: Notified listeners about logout');
    } catch (e) {
      Logger.error('AuthProvider: Logout failed with error: $e');
      rethrow;
    }
  }

  bool isGasPlantUser() {
    final result = _user?.isGasPlant ?? false;
    Logger.debug('AuthProvider: isGasPlantUser check, result: $result');
    return result;
  }
  
  bool isDistributorUser() {
    final result = _user?.isDistributor ?? false;
    Logger.debug('AuthProvider: isDistributorUser check, result: $result');
    return result;
  }

  // Update user profile
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
  }) async {
    if (_user == null) {
      Logger.warn('AuthProvider: Cannot update profile - user not logged in');
      return false;
    }

    Logger.debug('AuthProvider: Updating profile for user: ${_user!.id}');
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedData = await _profileService.updateProfile(
        userId: _user!.id,
        name: name,
        email: email,
        bio: bio,
        profileImageUrl: profileImageUrl,
        phoneNumber: phoneNumber,
        address: address,
      );

      if (updatedData != null) {
        // Update local user with new data (keep token)
        _user = UserModel(
          id: updatedData['id'] as String,
          name: updatedData['name'] as String,
          email: updatedData['email'] as String,
          role: updatedData['role'] as String,
          token: _user!.token, // Keep existing token
          bio: updatedData['bio'] as String? ?? '',
          profileImageUrl: updatedData['profileImageUrl'] as String? ?? '',
          phoneNumber: updatedData['phoneNumber'] as String? ?? '',
          address: updatedData['address'] as String? ?? '',
        );
        Logger.debug('AuthProvider: Profile updated successfully');
        _isLoadingProfile = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to update profile';
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('AuthProvider: Error updating profile: $e');
      _errorMessage = 'Failed to update profile: ${e.toString()}';
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh user profile from backend
  Future<void> refreshProfile() async {
    if (_user == null) {
      Logger.warn('AuthProvider: Cannot refresh profile - user not logged in');
      return;
    }

    Logger.debug('AuthProvider: Refreshing profile for user: ${_user!.id}');
    _isLoadingProfile = true;
    notifyListeners();

    try {
      final profileData = await _profileService.getProfile(_user!.id);

      if (profileData != null) {
        _user = UserModel(
          id: profileData['id'] as String,
          name: profileData['name'] as String,
          email: profileData['email'] as String,
          role: profileData['role'] as String,
          token: _user!.token, // Keep existing token
          bio: profileData['bio'] as String? ?? '',
          profileImageUrl: profileData['profileImageUrl'] as String? ?? '',
          phoneNumber: profileData['phoneNumber'] as String? ?? '',
          address: profileData['address'] as String? ?? '',
        );
        Logger.debug('AuthProvider: Profile refreshed successfully');
      }
    } catch (e) {
      Logger.error('AuthProvider: Error refreshing profile: $e');
    } finally {
      _isLoadingProfile = false;
      notifyListeners();
    }
  }

  // Change password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_user == null) {
      Logger.warn('AuthProvider: Cannot change password - user not logged in');
      return false;
    }

    Logger.debug('AuthProvider: Changing password for user: ${_user!.id}');
    _isLoadingProfile = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _profileService.changePassword(
        userId: _user!.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (success) {
        Logger.debug('AuthProvider: Password changed successfully');
        _isLoadingProfile = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to change password';
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('AuthProvider: Error changing password: $e');
      _errorMessage = 'Failed to change password: ${e.toString()}';
      _isLoadingProfile = false;
      notifyListeners();
      return false;
    }
  }

  // Getters
  UserModel? get user => _user;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoadingProfile => _isLoadingProfile;
  String? get errorMessage => _errorMessage;
}