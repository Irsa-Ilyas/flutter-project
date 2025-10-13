import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/service/order_service.dart';

class DistributorRequestViewModel extends BaseViewModel {
  final Map<double, int> _quantities = {
    15.0: 0,
    11.8: 0,
  };
  
  int _discount = 0;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;
  String _specialInstructions = '';
  
  // Per KG price - this would typically come from API
  final int perKgPrice = 250;
  
  // Order service
  final OrderService _orderService = OrderService();
  
  // Getters
  Map<double, int> get quantities => _quantities;
  int get discount => _discount;
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get specialInstructions => _specialInstructions;
  
  List<double> get cylinderWeights => _quantities.keys.toList();
  
  int get totalKg {
    return _quantities.values.reduce((a, b) => a + b);
  }
  
  int get totalPrice {
    final basePrice = totalKg * perKgPrice;
    final discountAmount = totalKg * _discount;
    return basePrice - discountAmount;
  }
  
  num getQuantity(double weight) {
    return _quantities[weight] ?? 0;
  }
  
  void increaseQuantity(double weight) {
    _quantities[weight] = (_quantities[weight] ?? 0) + 1;
    notifyListeners();
  }
  
  void decreaseQuantity(double weight) {
    if ((_quantities[weight] ?? 0) > 0) {
      _quantities[weight] = (_quantities[weight] ?? 0) - 1;
      notifyListeners();
    }
  }
  
  void setDiscount(int discount) {
    _discount = discount;
    notifyListeners();
  }
  
  void setSpecialInstructions(String instructions) {
    _specialInstructions = instructions;
    notifyListeners();
  }
  
  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
  
  Future<bool> submitRequest({
    required String plantName,
    required String plantImageUrl,
    required String specialInstructions,
    required String distributorId,
    required String distributorName,
    required String plantId,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
    
    try {
      // Check if any quantity is selected
      if (totalKg == 0) {
        _errorMessage = 'Please select at least one cylinder';
        notifyListeners();
        return false;
      }
      
      // Submit order to backend
      final success = await _orderService.submitOrder(
        distributorId: distributorId,
        distributorName: distributorName,
        plantId: plantId,
        plantName: plantName,
        plantImageUrl: plantImageUrl,
        quantities: _quantities,
        specialInstructions: specialInstructions,
        totalKg: totalKg,
        totalPrice: totalPrice,
      );
      
      if (success) {
        _successMessage = 'Request submitted successfully!';
        notifyListeners();
        
        // Reset quantities after successful submission
        _quantities.updateAll((key, value) => 0);
        _specialInstructions = '';
        notifyListeners();
        
        return true;
      } else {
        _errorMessage = 'Failed to submit request. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to submit request. Please try again.';
      notifyListeners();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}