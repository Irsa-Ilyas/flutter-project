import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';

class TankService extends BaseService {
  // Singleton instance
  static final TankService _instance = TankService._internal();
  factory TankService() => _instance;
  TankService._internal();

  // Get all tanks for an owner
  Future<List<TankModel>> getTanks(String ownerId) async {
    try {
      print('TankService: Fetching tanks for ownerId: $ownerId');
      final response = await dio.get('/api/tanks/owner/$ownerId');
      print('TankService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> tanksData = response.data;
        print('TankService: Found ${tanksData.length} tanks');

        final tanks =
            tanksData.map((tankData) => TankModel.fromJson(tankData)).toList();

        return tanks;
      }

      return [];
    } catch (e) {
      print('TankService: Error fetching tanks: $e');
      return [];
    }
  }

  // Get single tank by ID
  Future<TankModel?> getTankById(String tankId) async {
    try {
      print('TankService: Fetching tank with ID: $tankId');
      final response = await dio.get('/api/tanks/$tankId');

      if (response.statusCode == 200) {
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error fetching tank: $e');
      return null;
    }
  }

  // Create new tank
  Future<TankModel?> addTank({
    required String name,
    required String ownerId,
    required double totalCapacity,
    String location = '',
    double available = 0,
  }) async {
    try {
      print('TankService: Creating tank: $name');

      final tankData = {
        'name': name,
        'location': location,
        'totalCapacity': totalCapacity,
        'available': available,
        'ownerId': ownerId,
      };

      final response = await dio.post('/api/tanks', data: tankData);
      print('TankService: Tank created with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error creating tank: $e');
      rethrow;
    }
  }

  // Update tank
  Future<TankModel?> updateTank({
    required String tankId,
    String? name,
    String? location,
    double? totalCapacity,
    String? status,
  }) async {
    try {
      print('TankService: Updating tank: $tankId');

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (location != null) updateData['location'] = location;
      if (totalCapacity != null) updateData['totalCapacity'] = totalCapacity;
      if (status != null) updateData['status'] = status;

      final response = await dio.put('/api/tanks/$tankId', data: updateData);
      print('TankService: Tank updated with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error updating tank: $e');
      rethrow;
    }
  }

  // Delete tank
  Future<bool> deleteTank(String tankId) async {
    try {
      print('TankService: Deleting tank: $tankId');
      final response = await dio.delete('/api/tanks/$tankId');
      print('TankService: Tank deleted with status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('TankService: Error deleting tank: $e');
      return false;
    }
  }

  // Add gas to tank
  Future<TankModel?> addGasToTank({
    required String tankId,
    required double amount,
    double rate = 0,
  }) async {
    try {
      print('TankService: Adding gas to tank: $tankId, Amount: $amount tons');

      final response = await dio.post(
        '/api/tanks/$tankId/add-gas',
        data: {'amount': amount, 'rate': rate},
      );

      if (response.statusCode == 200) {
        print('TankService: Gas added successfully');
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error adding gas: $e');
      rethrow;
    }
  }

  // Freeze gas in tank
  Future<TankModel?> freezeGasInTank({
    required String tankId,
    required double amount,
  }) async {
    try {
      print('TankService: Freezing gas in tank: $tankId, Amount: $amount tons');

      final response = await dio.post(
        '/api/tanks/$tankId/freeze-gas',
        data: {'amount': amount},
      );

      if (response.statusCode == 200) {
        print('TankService: Gas frozen successfully');
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error freezing gas: $e');
      rethrow;
    }
  }

  // Unfreeze gas in tank
  Future<TankModel?> unfreezeGasInTank({
    required String tankId,
    required double amount,
  }) async {
    try {
      print('TankService: Unfreezing gas in tank: $tankId, Amount: $amount tons');

      final response = await dio.post(
        '/api/tanks/$tankId/unfreeze-gas',
        data: {'amount': amount},
      );

      if (response.statusCode == 200) {
        print('TankService: Gas unfrozen successfully');
        return TankModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('TankService: Error unfreezing gas: $e');
      rethrow;
    }
  }

  // Deduct stock from tanks (when order is placed)
  Future<bool> deductStock({
    required String ownerId,
    required double amount,
    required double rate,
    String orderId = '',
  }) async {
    try {
      print('TankService: Deducting stock - Amount: $amount tons');

      final response = await dio.post(
        '/api/tanks/deduct-stock',
        data: {
          'ownerId': ownerId,
          'amount': amount,
          'rate': rate,
          'orderId': orderId,
        },
      );

      if (response.statusCode == 200) {
        print('TankService: Stock deducted successfully');
        return true;
      }

      return false;
    } catch (e) {
      print('TankService: Error deducting stock: $e');
      return false;
    }
  }

  // Get transactions
  Future<List<StockTransaction>> getTransactions(String ownerId) async {
    try {
      print('TankService: Fetching transactions for ownerId: $ownerId');
      final response = await dio.get('/api/tanks/owner/$ownerId/transactions');

      if (response.statusCode == 200) {
        final List<dynamic> transactionsData = response.data;
        print('TankService: Found ${transactionsData.length} transactions');

        return transactionsData
            .map((data) => StockTransaction.fromJson(data))
            .toList();
      }

      return [];
    } catch (e) {
      print('TankService: Error fetching transactions: $e');
      return [];
    }
  }

  // Get stock statistics
  Future<Map<String, dynamic>?> getStockStats(String ownerId) async {
    try {
      print('TankService: Fetching stock stats for ownerId: $ownerId');
      final response = await dio.get('/api/tanks/owner/$ownerId/stats');

      if (response.statusCode == 200) {
        print('TankService: Stats received');
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('TankService: Error fetching stats: $e');
      return null;
    }
  }
}
