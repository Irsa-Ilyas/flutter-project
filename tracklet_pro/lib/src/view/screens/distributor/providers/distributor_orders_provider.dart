import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/model/order_model.dart';

// Distributor orders provider - yeh provider orders ke liye data manage krta hai
class DistributorOrdersProvider extends BaseViewModel {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  // Mock data - yeh mock data hai real app mein API se aayega
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'ORD-001',
      distributorName: 'Al-Rehman Distributors',
      plantName: 'City Gas Plant',
      totalKg: 150.0,
      totalPrice: 37500.0,
      status: 'Approved',
    ),
    OrderModel(
      id: 'ORD-002',
      distributorName: 'Hashim Traders',
      plantName: 'National Gas Plant',
      totalKg: 90.0,
      totalPrice: 22500.0,
      status: 'Approved',
    ),
    OrderModel(
      id: 'ORD-003',
      distributorName: 'Khan Enterprises',
      plantName: 'Premium Gas Plant',
      totalKg: 200.0,
      totalPrice: 50000.0,
      status: 'Pending',
    ),
  ];
  
  // Getters
  List<OrderModel> get orders => _orders;
  @override
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  // Approved orders only
  List<OrderModel> get approvedOrders {
    return _orders.where((order) => order.status == 'Approved').toList();
  }
  
  // Constructor
  DistributorOrdersProvider() {
    loadOrders();
  }
  
  // Load orders - yeh method orders load krta hai API se
  Future<void> loadOrders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      _orders = List.from(_mockOrders);
      // In real implementation, it would be:
      // final response = await ApiService.getOrders();
      // _orders = response.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      _errorMessage = 'Failed to load orders';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Refresh orders - yeh method orders refresh krta hai
  Future<void> refreshOrders() async {
    await loadOrders();
  }
  
  // Assign driver to order - yeh method order ko driver assign krta hai
  Future<bool> assignDriver(String orderId, String driverId) async {
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      
      // Update order status
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: 'Assigned',
          driverId: driverId,
        );
        notifyListeners();
        return true;
        // In real implementation, it would be:
        // final response = await ApiService.assignDriver(orderId, driverId);
        // if (response.success) {
        //   _orders[index] = _orders[index].copyWith(
        //     status: 'Assigned',
        //     driverId: driverId,
        //   );
        //   notifyListeners();
        //   return true;
        // }
        // return false;
      }
      
      _errorMessage = 'Order not found';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to assign driver';
      return false;
    }
  }
  
  // Update order status - yeh method order ka status update krta hai
  Future<bool> updateOrderStatus(String orderId, String status) async {
    _errorMessage = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      
      final index = _orders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: status);
        notifyListeners();
        return true;
      }
      
      _errorMessage = 'Order not found';
      return false;
    } catch (e) {
      _errorMessage = 'Failed to update order status';
      return false;
    }
  }
}