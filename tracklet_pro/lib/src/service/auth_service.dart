import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:tracklet_pro/src/utils/app_constants.dart';

class AuthService extends BaseService {
  // Flag to enable/disable mock mode
  static const bool useMockData = false; // Set to false when backend is ready

  AuthService() {
    dio.options.baseUrl = AppConstants.apiBaseUrl;
  }

  Future<UserModel> login(String email, String password) async {
    print('AuthService: Attempting login for email: $email');
    
    // Use mock data for testing
    if (useMockData) {
      print('AuthService: Using mock data for login');
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock login logic based on email
      if (email.contains('gasplant')) {
        print('AuthService: Mock gas plant user login');
        return UserModel(
          id: '1',
          name: 'Gas Plant User',
          email: email,
          role: 'gas_plant',
          token: 'gas_plant_token_123',
        );
      } else if (email.contains('distributor')) {
        print('AuthService: Mock distributor user login');
        return UserModel(
          id: '2',
          name: 'Distributor User',
          email: email,
          role: 'distributor',
          token: 'distributor_token_456',
        );
      } else {
        // Default user for testing
        print('AuthService: Mock default user login');
        return UserModel(
          id: '3',
          name: 'Test User',
          email: email,
          role: 'gas_plant', // Default to gas plant
          token: 'test_token_789',
        );
      }
    }

    try {
      print('AuthService: Making API call to /api/auth/login');
      final response = await dio.post('/api/auth/login', data: {
        'email': email,
        'password': password,
      });
      
      print('AuthService: API response status code: ${response.statusCode}');
      print('AuthService: API response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // Extract token and user data from response
        final token = response.data['token'] as String;
        // Assuming the backend returns user data in the response
        // If not, you might need to make a separate call to get user data
        final userData = response.data['user'] ?? {};
        
        print('AuthService: Token received: $token');
        print('AuthService: User data received: $userData');
        
        final user = UserModel(
          id: userData['id']?.toString() ?? '1',
          name: userData['name']?.toString() ?? 'User',
          email: userData['email']?.toString() ?? email,
          role: userData['role']?.toString() ?? _determineRoleFromEmail(email),
          token: token,
        );
        
        print('AuthService: Created UserModel with role: ${user.role}');
        return user;
      } else {
        print('AuthService: Login failed with status: ${response.statusMessage}');
        throw Exception('Login failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('AuthService: DioException occurred during login');
      print('AuthService: DioException type: ${e.type}');
      print('AuthService: DioException message: ${e.message}');
      print('AuthService: DioException error: ${e.error}');
      print('AuthService: DioException request options: ${e.requestOptions}');
      
      if (e.response != null) {
        print('AuthService: Error response status code: ${e.response?.statusCode}');
        print('AuthService: Error response data: ${e.response?.data}');
        print('AuthService: Error response headers: ${e.response?.headers}');
        
        // More detailed error parsing
        String errorMessage = 'Login failed';
        if (e.response?.data is Map) {
          final errorData = e.response?.data as Map;
          errorMessage = errorData['msg'] ?? errorData['message'] ?? errorData.toString();
        } else if (e.response?.data != null) {
          errorMessage = e.response?.data.toString() ?? 'Unknown error';
        }
        
        print('AuthService: Parsed error message: $errorMessage');
        throw Exception(errorMessage);
      } else {
        print('AuthService: Network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      print('AuthService: Unexpected error during login: $e');
      print('AuthService: Stack trace: $stackTrace');
      throw Exception('Login failed: $e');
    }
  }

  Future<UserModel> register(String name, String email, String password) async {
    print('AuthService: Attempting registration for email: $email');
    
    // Use mock data for testing
    if (useMockData) {
      print('AuthService: Using mock data for registration');
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final role = _determineRoleFromEmail(email);
      print('AuthService: Determined role for registration: $role');
      
      return UserModel(
        id: '1',
        name: name,
        email: email,
        role: role,
        token: 'test_token_789',
      );
    }

    try {
      print('AuthService: Making API call to /api/auth/register');
      final response = await dio.post('/api/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'role': _determineRoleFromEmail(email), // Set role based on email
      });
      
      print('AuthService: Registration API response status code: ${response.statusCode}');
      print('AuthService: Registration API response data: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        // Extract token from response
        final token = response.data['token'] as String;
        // Assuming the backend returns user data in the response
        final userData = response.data['user'] ?? {};
        
        print('AuthService: Registration token received: $token');
        print('AuthService: Registration user data received: $userData');
        
        final user = UserModel(
          id: userData['id']?.toString() ?? '1',
          name: userData['name']?.toString() ?? name,
          email: userData['email']?.toString() ?? email,
          role: userData['role']?.toString() ?? _determineRoleFromEmail(email),
          token: token,
        );
        
        print('AuthService: Created UserModel for registration with role: ${user.role}');
        return user;
      } else {
        print('AuthService: Registration failed with status: ${response.statusMessage}');
        throw Exception('Registration failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('AuthService: DioException occurred during registration');
      print('AuthService: DioException type: ${e.type}');
      print('AuthService: DioException message: ${e.message}');
      print('AuthService: DioException response: ${e.response}');
      
      if (e.response != null) {
        print('AuthService: Registration error response status code: ${e.response?.statusCode}');
        print('AuthService: Registration error response data: ${e.response?.data}');
        throw Exception('Registration failed: ${e.response?.data['msg'] ?? e.response?.statusMessage}');
      } else {
        print('AuthService: Registration network error: ${e.message}');
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('AuthService: Unexpected error during registration: $e');
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      print('AuthService: Attempting logout');
      // Example API call
      // await dio.post('/auth/logout');
      print('AuthService: Logout completed');
    } catch (e) {
      print('AuthService: Error during logout: $e');
      rethrow;
    }
  }
  
  // Helper method to determine role based on email
  String _determineRoleFromEmail(String email) {
    print('AuthService: Determining role for email: $email');
    if (email.contains('gasplant') || email.contains('plant')) {
      print('AuthService: Role determined as gas_plant');
      return 'gas_plant';
    } else if (email.contains('distributor')) {
      print('AuthService: Role determined as distributor');
      return 'distributor';
    } else {
      // Default role
      print('AuthService: Role defaulted to gas_plant');
      return 'gas_plant';
    }
  }
}