import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';
import 'package:tracklet_pro/src/service/tank_service.dart';

/// View Model for Gas Plant Stock Management
/// Handles network operations and business logic for stock
class StockViewModel extends ChangeNotifier {
  final TankService _tankService = TankService();

  /// Load all tanks data for an owner
  Future<List<TankModel>> loadTanks(String ownerId) async {
    try {
      return await _tankService.getTanks(ownerId);
    } catch (e) {
      debugPrint('StockViewModel: Error loading tanks: $e');
      return [];
    }
  }

  /// Add gas to a specific tank
  Future<TankModel?> addGasToTank(String tankId, double amount) async {
    try {
      return await _tankService.addGasToTank(tankId: tankId, amount: amount);
    } catch (e) {
      debugPrint('StockViewModel: Error adding gas: $e');
      return null;
    }
  }

  /// Freeze gas in a specific tank
  Future<TankModel?> freezeGasInTank(String tankId, double amount) async {
    try {
      return await _tankService.freezeGasInTank(tankId: tankId, amount: amount);
    } catch (e) {
      debugPrint('StockViewModel: Error freezing gas: $e');
      return null;
    }
  }

  /// Add a new tank
  Future<TankModel?> addNewTank({
    required String name,
    required String ownerId,
    required double totalCapacity,
    String location = '',
    double available = 0,
  }) async {
    try {
      return await _tankService.addTank(
        name: name,
        ownerId: ownerId,
        totalCapacity: totalCapacity,
        location: location,
        available: available,
      );
    } catch (e) {
      debugPrint('StockViewModel: Error adding new tank: $e');
      return null;
    }
  }

  /// Deduct stock for an order
  Future<bool> deductStockForOrder({
    required String ownerId,
    required double amountInKg,
    required double rate,
    required String orderId,
  }) async {
    try {
      return await _tankService.deductStock(
        ownerId: ownerId,
        amount: amountInKg,
        rate: rate,
        orderId: orderId,
      );
    } catch (e) {
      debugPrint('StockViewModel: Error deducting stock: $e');
      return false;
    }
  }
}
