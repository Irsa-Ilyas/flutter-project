import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/plant_model.dart';

class PlantService extends BaseService {
  // Singleton instance
  static final PlantService _instance = PlantService._internal();
  factory PlantService() => _instance;
  PlantService._internal();

  // Get all active plants
  Future<List<PlantModel>> getAllPlants() async {
    try {
      print('PlantService: Fetching all plants');
      final response = await dio.get('/api/plants');
      print('PlantService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> plantsData = response.data;
        print('PlantService: Found ${plantsData.length} plants');

        final plants = plantsData
            .map((plantData) => PlantModel.fromJson(plantData))
            .toList();

        return plants;
      }

      return [];
    } catch (e) {
      print('PlantService: Error fetching plants: $e');
      return [];
    }
  }

  // Get plant by ID
  Future<PlantModel?> getPlantById(String plantId) async {
    try {
      print('PlantService: Fetching plant with ID: $plantId');
      final response = await dio.get('/api/plants/$plantId');

      if (response.statusCode == 200) {
        return PlantModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('PlantService: Error fetching plant: $e');
      return null;
    }
  }

  // Create new plant
  Future<PlantModel?> createPlant({
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
    try {
      print('PlantService: Creating plant: $name');

      final plantData = {
        'name': name,
        'location': location,
        'city': city,
        'contactNumber': contactNumber,
        'email': email,
        'perKgPrice': perKgPrice,
        'imageUrl':
            imageUrl ?? 'https://via.placeholder.com/400x200?text=Gas+Plant',
        'totalCapacity': totalCapacity,
        'currentStock': currentStock,
        'ownerId': ownerId,
      };

      final response = await dio.post('/api/plants', data: plantData);
      print('PlantService: Plant created with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PlantModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('PlantService: Error creating plant: $e');
      return null;
    }
  }

  // Update plant
  Future<PlantModel?> updatePlant({
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
    try {
      print('PlantService: Updating plant: $plantId');

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (location != null) updateData['location'] = location;
      if (city != null) updateData['city'] = city;
      if (contactNumber != null) updateData['contactNumber'] = contactNumber;
      if (email != null) updateData['email'] = email;
      if (perKgPrice != null) updateData['perKgPrice'] = perKgPrice;
      if (imageUrl != null) updateData['imageUrl'] = imageUrl;
      if (totalCapacity != null) updateData['totalCapacity'] = totalCapacity;
      if (currentStock != null) updateData['currentStock'] = currentStock;
      if (status != null) updateData['status'] = status;

      final response = await dio.put('/api/plants/$plantId', data: updateData);
      print('PlantService: Plant updated with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return PlantModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('PlantService: Error updating plant: $e');
      return null;
    }
  }

  // Delete plant (soft delete)
  Future<bool> deletePlant(String plantId) async {
    try {
      print('PlantService: Deleting plant: $plantId');
      final response = await dio.delete('/api/plants/$plantId');
      print('PlantService: Plant deleted with status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('PlantService: Error deleting plant: $e');
      return false;
    }
  }
}
