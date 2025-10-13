import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/plant_model.dart';
import 'package:tracklet_pro/src/service/plant_service.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class PlantProvider extends ChangeNotifier {
  final PlantService _plantService = PlantService();

  List<PlantModel> _plants = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<PlantModel> get plants => _plants;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get active plants only
  List<PlantModel> get activePlants =>
      _plants.where((p) => p.status == 'active').toList();

  // Fetch all plants
  Future<void> fetchPlants() async {
    Logger.debug('PlantProvider: Fetching plants');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _plants = await _plantService.getAllPlants();
      Logger.debug('PlantProvider: Fetched ${_plants.length} plants');
      _errorMessage = null;
    } catch (e) {
      Logger.error('PlantProvider: Error fetching plants: $e');
      _errorMessage = 'Failed to fetch plants';
      _plants = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create new plant
  Future<bool> createPlant({
    required String name,
    required String location,
    required String city,
    required String contactNumber,
    required String email,
    required String ownerId,
    int perKgPrice = 250,
    String? imageUrl,
    double totalCapacity = 0,
    double currentStock = 0,
  }) async {
    Logger.debug('PlantProvider: Creating plant: $name');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final plant = await _plantService.createPlant(
        name: name,
        location: location,
        city: city,
        contactNumber: contactNumber,
        email: email,
        ownerId: ownerId,
        perKgPrice: perKgPrice,
        imageUrl: imageUrl,
        totalCapacity: totalCapacity,
        currentStock: currentStock,
      );

      if (plant != null) {
        _plants.add(plant);
        Logger.debug('PlantProvider: Plant created successfully');
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to create plant';
      return false;
    } catch (e) {
      Logger.error('PlantProvider: Error creating plant: $e');
      _errorMessage = 'Failed to create plant: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update plant
  Future<bool> updatePlant({
    required String plantId,
    String? name,
    String? location,
    String? city,
    String? contactNumber,
    String? email,
    int? perKgPrice,
    String? imageUrl,
    double? totalCapacity,
    double? currentStock,
    String? status,
  }) async {
    Logger.debug('PlantProvider: Updating plant: $plantId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedPlant = await _plantService.updatePlant(
        plantId: plantId,
        name: name,
        location: location,
        city: city,
        contactNumber: contactNumber,
        email: email,
        perKgPrice: perKgPrice,
        imageUrl: imageUrl,
        totalCapacity: totalCapacity,
        currentStock: currentStock,
        status: status,
      );

      if (updatedPlant != null) {
        // Update in local list
        final index = _plants.indexWhere((p) => p.id == plantId);
        if (index != -1) {
          _plants[index] = updatedPlant;
        }
        Logger.debug('PlantProvider: Plant updated successfully');
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to update plant';
      return false;
    } catch (e) {
      Logger.error('PlantProvider: Error updating plant: $e');
      _errorMessage = 'Failed to update plant: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete plant
  Future<bool> deletePlant(String plantId) async {
    Logger.debug('PlantProvider: Deleting plant: $plantId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _plantService.deletePlant(plantId);

      if (success) {
        // Remove from local list or mark as inactive
        _plants.removeWhere((p) => p.id == plantId);
        Logger.debug('PlantProvider: Plant deleted successfully');
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to delete plant';
      return false;
    } catch (e) {
      Logger.error('PlantProvider: Error deleting plant: $e');
      _errorMessage = 'Failed to delete plant: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get plant by ID
  Future<PlantModel?> getPlantById(String plantId) async {
    try {
      Logger.debug('PlantProvider: Getting plant by ID: $plantId');
      return await _plantService.getPlantById(plantId);
    } catch (e) {
      Logger.error('PlantProvider: Error getting plant: $e');
      return null;
    }
  }

  // Refresh plants
  Future<void> refresh() async {
    await fetchPlants();
  }
}