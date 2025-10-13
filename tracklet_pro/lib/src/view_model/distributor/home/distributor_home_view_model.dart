import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/service/order_service.dart';

/// View Model for Distributor Home/Dashboard
/// Handles network operations and business logic
class DistributorHomeViewModel extends ChangeNotifier {
  final OrderService _orderService = OrderService();

  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  // Per KG price - this would typically come from API
  final int perKgPrice = 250;

  // Getters
  bool get isSubmitting => _isSubmitting;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  int calculateTotalPrice(int totalKg, int discount) {
    final basePrice = totalKg * perKgPrice;
    final discountAmount = totalKg * discount;
    return basePrice - discountAmount;
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
    required Map<double, int> quantities,
    required int totalKg,
    required int totalPrice,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      if (totalKg == 0) {
        _errorMessage = 'Please select at least one cylinder';
        _isSubmitting = false;
        notifyListeners();
        return false;
      }

      final success = await _orderService.submitOrder(
        distributorId: distributorId,
        distributorName: distributorName,
        plantId: plantId,
        plantName: plantName,
        plantImageUrl: plantImageUrl,
        quantities: quantities,
        specialInstructions: specialInstructions,
        totalKg: totalKg,
        totalPrice: totalPrice,
      );

      if (success) {
        _successMessage = 'Request submitted successfully!';
        _isSubmitting = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to submit request. Please try again.';
        _isSubmitting = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to submit request. Please try again.';
      _isSubmitting = false;
      notifyListeners();
      return false;
    }
  }
}
