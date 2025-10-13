import 'package:flutter/foundation.dart';

/// Provider for Distributor Home/Dashboard
/// Handles state management for distributor dashboard UI
class DistributorHomeProvider extends ChangeNotifier {
  final Map<double, int> _quantities = {15.0: 0, 11.8: 0};

  int _discount = 0;
  String _specialInstructions = '';

  // Getters
  Map<double, int> get quantities => _quantities;
  int get discount => _discount;
  String get specialInstructions => _specialInstructions;

  List<double> get cylinderWeights => _quantities.keys.toList();

  int get totalKg {
    return _quantities.values.reduce((a, b) => a + b);
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

  void resetQuantities() {
    _quantities.updateAll((key, value) => 0);
    _specialInstructions = '';
    notifyListeners();
  }
}
