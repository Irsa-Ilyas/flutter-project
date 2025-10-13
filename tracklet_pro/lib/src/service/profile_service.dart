import 'package:tracklet_pro/src/service/base_service.dart';

class ProfileService extends BaseService {
  // Singleton instance
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  // Get user profile
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      print('ProfileService: Fetching profile for userId: $userId');
      final response = await dio.get('/api/profile/$userId');
      print('ProfileService: Profile fetch status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('ProfileService: Profile data received');
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('ProfileService: Error fetching profile: $e');
      return null;
    }
  }

  // Update user profile
  Future<Map<String, dynamic>?> updateProfile({
    required String userId,
    String? name,
    String? email,
    String? bio,
    String? profileImageUrl,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      print('ProfileService: Updating profile for userId: $userId');

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (bio != null) updateData['bio'] = bio;
      if (profileImageUrl != null) updateData['profileImageUrl'] = profileImageUrl;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (address != null) updateData['address'] = address;

      final response = await dio.put('/api/profile/$userId', data: updateData);
      print('ProfileService: Profile update status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('ProfileService: Profile updated successfully');
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('ProfileService: Error updating profile: $e');
      rethrow;
    }
  }

  // Change password
  Future<bool> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('ProfileService: Changing password for userId: $userId');

      final response = await dio.put(
        '/api/profile/$userId/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      print('ProfileService: Password change status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('ProfileService: Error changing password: $e');
      rethrow;
    }
  }
}

