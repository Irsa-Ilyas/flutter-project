import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';
import 'package:tracklet_pro/src/service/tank_service.dart';

class TotalStockViewModel extends BaseViewModel {
  final TankService _tankService = TankService();
  
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
  @override
  bool get isLoading => _isLoading;
  
  bool _isAddingGas = false;
  bool get isAddingGas => _isAddingGas;
  
  bool _isFreezingGas = false;
  bool get isFreezingGas => _isFreezingGas;

  // Error handling
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Load all tanks data
  Future<void> loadTanks({String ownerId = 'default'}) async {
    if (_isLoading) return;
    
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tanks = await _tankService.getTanks(ownerId);
      _calculateSummaryData();
    } catch (e) {
      _errorMessage = 'Failed to load tanks: ${e.toString()}';
      debugPrint('Error loading tanks: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calculate summary data from tanks
  void _calculateSummaryData() {
    _totalStock = _tanks.fold(0.0, (sum, tank) => sum + tank.available);
    _freezeGas = _tanks.fold(0.0, (sum, tank) => sum + tank.freezeGas);
  }

  // Add gas to a specific tank
  Future<bool> addGasToTank(String tankId, double amount, {String ownerId = 'default'}) async {
    _isAddingGas = true;
    notifyListeners();

    try {
      final updatedTank = await _tankService.addGasToTank(
        tankId: tankId,
        amount: amount,
      );
      if (updatedTank != null) {
        // Refresh tank data
        await loadTanks(ownerId: ownerId);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add gas: ${e.toString()}';
      debugPrint('Error adding gas: $e');
      return false;
    } finally {
      _isAddingGas = false;
      notifyListeners();
    }
  }

  // Freeze gas in a specific tank
  Future<bool> freezeGasInTank(String tankId, double amount, {String ownerId = 'default'}) async {
    _isFreezingGas = true;
    notifyListeners();

    try {
      final updatedTank = await _tankService.freezeGasInTank(
        tankId: tankId,
        amount: amount,
      );
      if (updatedTank != null) {
        // Refresh tank data
        await loadTanks(ownerId: ownerId);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to freeze gas: ${e.toString()}';
      debugPrint('Error freezing gas: $e');
      return false;
    } finally {
      _isFreezingGas = false;
      notifyListeners();
    }
  }

  // Add a new tank
  Future<bool> addNewTank({
    required String name,
    required String ownerId,
    required double totalCapacity,
    String location = '',
    double available = 0,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTank = await _tankService.addTank(
        name: name,
        ownerId: ownerId,
        totalCapacity: totalCapacity,
        location: location,
        available: available,
      );
      if (newTank != null) {
        _tanks.add(newTank);
        _calculateSummaryData();
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Failed to add new tank: ${e.toString()}';
      debugPrint('Error adding new tank: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}