import 'dart:io';
import 'dart:convert';

Future<void> testOrderFlow() async {
  try {
    print('Testing order flow...');
    
    final baseUrl = 'http://localhost:5000/api';
    
    // Test creating an order
    print('Creating a test order...');
    final orderData = {
      'distributorId': 'dist_123',
      'distributorName': 'Test Distributor',
      'plantId': 'plant_456',
      'plantName': 'Test Gas Plant',
      'plantImageUrl': 'https://example.com/plant.jpg',
      'items': [
        {'weight': 15.0, 'quantity': 2},
        {'weight': 11.8, 'quantity': 3}
      ],
      'specialInstructions': 'Please deliver after 2 PM',
      'totalKg': 65.4,
      'totalPrice': 16350
    };
    
    final createRequest = await HttpClient().postUrl(Uri.parse('$baseUrl/orders'));
    createRequest.headers.set('Content-Type', 'application/json');
    createRequest.write(jsonEncode(orderData));
    
    final createResponse = await createRequest.close();
    print('Create order status: ${createResponse.statusCode}');
    
    if (createResponse.statusCode == 200 || createResponse.statusCode == 201) {
      final createData = await createResponse.transform(utf8.decoder).join();
      print('Order created successfully: $createData');
      
      // Parse the created order to get its ID
      final createdOrder = jsonDecode(createData);
      final orderId = createdOrder['_id'];
      print('Created order ID: $orderId');
      
      // Test fetching orders for the plant
      print('Fetching orders for plant...');
      final getRequest = await HttpClient().getUrl(Uri.parse('$baseUrl/orders/plant/plant_456'));
      final getResponse = await getRequest.close();
      print('Get orders status: ${getResponse.statusCode}');
      
      if (getResponse.statusCode == 200) {
        final getData = await getResponse.transform(utf8.decoder).join();
        print('Orders fetched successfully: $getData');
      } else {
        final errorData = await getResponse.transform(utf8.decoder).join();
        print('Get orders failed: $errorData');
      }
      
      // Test accepting the order
      print('Accepting the order...');
      final acceptRequest = await HttpClient().putUrl(Uri.parse('$baseUrl/orders/$orderId/accept'));
      acceptRequest.headers.set('Content-Type', 'application/json');
      acceptRequest.write(jsonEncode({'driverName': 'Test Driver'}));
      
      final acceptResponse = await acceptRequest.close();
      print('Accept order status: ${acceptResponse.statusCode}');
      
      if (acceptResponse.statusCode == 200) {
        final acceptData = await acceptResponse.transform(utf8.decoder).join();
        print('Order accepted successfully: $acceptData');
      } else {
        final errorData = await acceptResponse.transform(utf8.decoder).join();
        print('Accept order failed: $errorData');
      }
    } else {
      final errorData = await createResponse.transform(utf8.decoder).join();
      print('Create order failed: $errorData');
    }
    
  } catch (e) {
    print('Order flow test failed: $e');
  }
}

void main() {
  testOrderFlow();
}