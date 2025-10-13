import 'package:dio/dio.dart';
import 'package:tracklet_pro/src/utils/app_constants.dart';

class BaseService {
  late Dio dio;

  BaseService() {
    dio = Dio();
    // Add base configuration for Dio here
    dio.options.baseUrl = AppConstants.apiBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add logging interceptor for debugging
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        logPrint: (obj) => print('DIO: $obj'),
      ),
    );
  }
}
