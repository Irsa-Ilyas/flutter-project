import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';

/// Provider for Gas Plant Stock Management
/// Handles state management for stock-related UI
class StockProvider extends ChangeNotifier {
  // Tank data
  List<TankModel> _tanks = [];
  List<TankModel> get tanks => _tanks;

  // Summary data
  double _totalStock = 0.0;
  double get totalStock => _totalStock;

  double _freezeGas = 0.0;
  double get freezeGas => _freezeGas;

  // Loading states
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isAddingGas = false;
  bool get isAddingGas => _isAddingGas;

  bool _isFreezingGas = false;
  bool get isFreezingGas => _isFreezingGas;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Update tanks from view model
  void updateTanks(List<TankModel> tanks) {
    _tanks = tanks;
    _calculateSummaryData();
    notifyListeners();
  }

  /// Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// Set adding gas state
  void setAddingGas(bool adding) {
    _isAddingGas = adding;
    notifyListeners();
  }

  /// Set freezing gas state
  void setFreezingGas(bool freezing) {
    _isFreezingGas = freezing;
    notifyListeners();
  }

  /// Set error message
  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Calculate summary data from tanks
  void _calculateSummaryData() {
    _totalStock = _tanks.fold(0.0, (sum, tank) => sum + tank.available);
    _freezeGas = _tanks.fold(0.0, (sum, tank) => sum + tank.freezeGas);
  }

  /// Add a new tank to the list
  void addTank(TankModel tank) {
    _tanks.add(tank);
    _calculateSummaryData();
    notifyListeners();
  }
}
