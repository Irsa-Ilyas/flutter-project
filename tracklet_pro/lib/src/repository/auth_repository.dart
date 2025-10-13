import 'package:tracklet_pro/src/model/user_model.dart';

class AuthRepository {

  Future<UserModel> login(String email, String password) async {
    try {
      // In a real app, you would call the auth service here
      // For now, we'll return a mock user based on email
      if (email.contains('gasplant')) {
        return UserModel(
          id: '1',
          name: 'Gas Plant User',
          email: email,
          role: 'gas_plant',
          token: 'gas_plant_token_123',
        );
      } else if (email.contains('distributor')) {
        return UserModel(
          id: '2',
          name: 'Distributor User',
          email: email,
          role: 'distributor',
          token: 'distributor_token_456',
        );
      } else {
        // Default user for testing
        return UserModel(
          id: '3',
          name: 'Test User',
          email: email,
          role: 'gas_plant', // Default to gas plant
          token: 'test_token_789',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // Perform logout operations
      // Clear user data, tokens, etc.
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    // Check if user is logged in (check token, etc.)
    return false; // For now, return false
  }
}