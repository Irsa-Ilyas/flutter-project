import 'package:dio/dio.dart';

Future<void> main() async {
  final dio = Dio();
  dio.options.baseUrl = 'http://localhost:5000';

  try {
    // Test registration
    print('Testing registration...');
    final registerResponse = await dio.post('/api/auth/register', data: {
      'name': 'Test User',
      'email': 'test@example.com',
      'password': 'password123'
    });
    
    print('Registration response: ${registerResponse.data}');
    
    // Test login
    print('Testing login...');
    final loginResponse = await dio.post('/api/auth/login', data: {
      'email': 'test@example.com',
      'password': 'password123'
    });
    
    print('Login response: ${loginResponse.data}');
    
  } on DioException catch (e) {
    print('Error: ${e.response?.data ?? e.message}');
  } catch (e) {
    print('Error: $e');
  }
}