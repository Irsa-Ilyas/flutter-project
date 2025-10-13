import 'package:dio/dio.dart';
import 'package:tracklet_super_admin/src/utils/app_constants.dart';

class BaseService {
  final Dio dio;

  BaseService() : dio = Dio() {
    dio.options.baseUrl = AppConstants.apiBaseUrl;
    dio.options.connectTimeout = AppConstants.connectTimeout;
    dio.options.receiveTimeout = AppConstants.receiveTimeout;
    
    // Add interceptors for debugging
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
        requestHeader: true,
        responseHeader: false,
      ),
    );
  }

  // Set authorization token
  void setAuthToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear authorization token
  void clearAuthToken() {
    dio.options.headers.remove('Authorization');
  }
}

