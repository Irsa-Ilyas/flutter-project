import 'dart:io';
import 'dart:convert';

Future<void> testAPI() async {
  try {
    print('Testing API connection...');
    
    // Test base URL
    final baseUrl = 'http://localhost:5000';
    
    // Test health endpoint
    final healthUrl = '$baseUrl/health';
    print('Testing health endpoint: $healthUrl');
    
    final healthRequest = await HttpClient().getUrl(Uri.parse(healthUrl));
    final healthResponse = await healthRequest.close();
    
    if (healthResponse.statusCode == 200) {
      final healthData = await healthResponse.transform(utf8.decoder).join();
      print('Health check successful: $healthData');
    } else {
      print('Health check failed with status: ${healthResponse.statusCode}');
    }
    
    // Test API orders endpoint
    final ordersUrl = '$baseUrl/api/orders/plant/test_plant';
    print('Testing orders endpoint: $ordersUrl');
    
    final ordersRequest = await HttpClient().getUrl(Uri.parse(ordersUrl));
    final ordersResponse = await ordersRequest.close();
    
    print('Orders endpoint status: ${ordersResponse.statusCode}');
    
    if (ordersResponse.statusCode == 200) {
      final ordersData = await ordersResponse.transform(utf8.decoder).join();
      print('Orders data: $ordersData');
    } else {
      final errorData = await ordersResponse.transform(utf8.decoder).join();
      print('Orders error: $errorData');
    }
    
  } catch (e) {
    print('API test failed: $e');
  }
}

void main() {
  testAPI();
}