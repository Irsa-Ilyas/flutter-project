import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';
import 'package:tracklet_pro/src/service/tank_service.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class StockProvider extends ChangeNotifier {
  final TankService _tankService = TankService();

  List<TankModel> _tanks = [];
  List<StockTransaction> _transactions = [];
  Map<String, dynamic>? _stats;

  bool _isLoading = false;
  bool _isAddingGas = false;
  bool _isFreezingGas = false;
  String? _errorMessage;

  // Getters
  List<TankModel> get tanks => _tanks;
  List<StockTransaction> get transactions => _transactions;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  bool get isAddingGas => _isAddingGas;
  bool get isFreezingGas => _isFreezingGas;
  String? get errorMessage => _errorMessage;

  // Calculated getters
  double get totalStock =>
      _tanks.fold(0.0, (sum, tank) => sum + tank.available);

  double get freezeGas =>
      _tanks.fold(0.0, (sum, tank) => sum + tank.freezeGas);

  double get totalCapacity =>
      _tanks.fold(0.0, (sum, tank) => sum + tank.totalCapacity);

  List<TankModel> get activeTanks =>
      _tanks.where((tank) => tank.isActive).toList();

  // Fetch all tanks
  Future<void> fetchTanks(String ownerId) async {
    Logger.debug('StockProvider: Fetching tanks for ownerId: $ownerId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tanks = await _tankService.getTanks(ownerId);
      Logger.debug('StockProvider: Fetched ${_tanks.length} tanks');
      _errorMessage = null;
    } catch (e) {
      Logger.error('StockProvider: Error fetching tanks: $e');
      _errorMessage = 'Failed to fetch tanks';
      _tanks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add new tank
  Future<bool> addTank({
    required String name,
    required String ownerId,
    required double totalCapacity,
    String location = '',
    double available = 0,
  }) async {
    Logger.debug('StockProvider: Adding tank: $name');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tank = await _tankService.addTank(
        name: name,
        ownerId: ownerId,
        totalCapacity: totalCapacity,
        location: location,
        available: available,
      );

      if (tank != null) {
        _tanks.add(tank);
        Logger.debug('StockProvider: Tank added successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to add tank';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error adding tank: $e');
      _errorMessage = 'Failed to add tank: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update tank
  Future<bool> updateTank({
    required String tankId,
    String? name,
    String? location,
    double? totalCapacity,
    String? status,
  }) async {
    Logger.debug('StockProvider: Updating tank: $tankId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTank = await _tankService.updateTank(
        tankId: tankId,
        name: name,
        location: location,
        totalCapacity: totalCapacity,
        status: status,
      );

      if (updatedTank != null) {
        final index = _tanks.indexWhere((t) => t.id == tankId);
        if (index != -1) {
          _tanks[index] = updatedTank;
        }
        Logger.debug('StockProvider: Tank updated successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to update tank';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error updating tank: $e');
      _errorMessage = 'Failed to update tank: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete tank
  Future<bool> deleteTank(String tankId) async {
    Logger.debug('StockProvider: Deleting tank: $tankId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _tankService.deleteTank(tankId);

      if (success) {
        _tanks.removeWhere((t) => t.id == tankId);
        Logger.debug('StockProvider: Tank deleted successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to delete tank';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error deleting tank: $e');
      _errorMessage = 'Failed to delete tank: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add gas to tank
  Future<bool> addGasToTank({
    required String tankId,
    required double amount,
    required String ownerId,
    double rate = 0,
  }) async {
    Logger.debug('StockProvider: Adding gas to tank: $tankId, Amount: $amount tons');
    _isAddingGas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTank = await _tankService.addGasToTank(
        tankId: tankId,
        amount: amount,
        rate: rate,
      );

      if (updatedTank != null) {
        final index = _tanks.indexWhere((t) => t.id == tankId);
        if (index != -1) {
          _tanks[index] = updatedTank;
        }
        Logger.debug('StockProvider: Gas added successfully');
        _isAddingGas = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to add gas';
      _isAddingGas = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error adding gas: $e');
      _errorMessage = e.toString().contains('capacity')
          ? 'Exceeds tank capacity'
          : 'Failed to add gas: ${e.toString()}';
      _isAddingGas = false;
      notifyListeners();
      return false;
    }
  }

  // Freeze gas in tank
  Future<bool> freezeGasInTank({
    required String tankId,
    required double amount,
    required String ownerId,
  }) async {
    Logger.debug('StockProvider: Freezing gas in tank: $tankId, Amount: $amount tons');
    _isFreezingGas = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTank = await _tankService.freezeGasInTank(
        tankId: tankId,
        amount: amount,
      );

      if (updatedTank != null) {
        final index = _tanks.indexWhere((t) => t.id == tankId);
        if (index != -1) {
          _tanks[index] = updatedTank;
        }
        Logger.debug('StockProvider: Gas frozen successfully');
        _isFreezingGas = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to freeze gas';
      _isFreezingGas = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error freezing gas: $e');
      _errorMessage = e.toString().contains('enough')
          ? 'Not enough available gas'
          : 'Failed to freeze gas: ${e.toString()}';
      _isFreezingGas = false;
      notifyListeners();
      return false;
    }
  }

  // Unfreeze gas in tank
  Future<bool> unfreezeGasInTank({
    required String tankId,
    required double amount,
    required String ownerId,
  }) async {
    Logger.debug('StockProvider: Unfreezing gas in tank: $tankId, Amount: $amount tons');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedTank = await _tankService.unfreezeGasInTank(
        tankId: tankId,
        amount: amount,
      );

      if (updatedTank != null) {
        final index = _tanks.indexWhere((t) => t.id == tankId);
        if (index != -1) {
          _tanks[index] = updatedTank;
        }
        Logger.debug('StockProvider: Gas unfrozen successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to unfreeze gas';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error unfreezing gas: $e');
      _errorMessage = 'Failed to unfreeze gas: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Deduct stock (called when order is accepted)
  Future<bool> deductStockForOrder({
    required String ownerId,
    required double amountInKg,
    required double rate,
    String orderId = '',
  }) async {
    final amountInTons = amountInKg / 1000;
    Logger.debug('StockProvider: Deducting $amountInKg kg ($amountInTons tons) for order');

    try {
      final success = await _tankService.deductStock(
        ownerId: ownerId,
        amount: amountInTons,
        rate: rate,
        orderId: orderId,
      );

      if (success) {
        // Refresh tanks to show updated stock
        await fetchTanks(ownerId);
        return true;
      }

      _errorMessage = 'Not enough stock available';
      return false;
    } catch (e) {
      Logger.error('StockProvider: Error deducting stock: $e');
      _errorMessage = 'Failed to deduct stock: ${e.toString()}';
      return false;
    }
  }

  // Fetch transactions
  Future<void> fetchTransactions(String ownerId) async {
    try {
      _transactions = await _tankService.getTransactions(ownerId);
      notifyListeners();
    } catch (e) {
      Logger.error('StockProvider: Error fetching transactions: $e');
    }
  }

  // Fetch statistics
  Future<void> fetchStats(String ownerId) async {
    try {
      _stats = await _tankService.getStockStats(ownerId);
      notifyListeners();
    } catch (e) {
      Logger.error('StockProvider: Error fetching stats: $e');
    }
  }

  // Refresh all data
  Future<void> refresh(String ownerId) async {
    await fetchTanks(ownerId);
    await fetchTransactions(ownerId);
    await fetchStats(ownerId);
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}