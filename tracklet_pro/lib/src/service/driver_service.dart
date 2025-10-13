import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/employee_model.dart';

class DriverService extends BaseService {
  // Singleton instance
  static final DriverService _instance = DriverService._internal();
  factory DriverService() => _instance;
  DriverService._internal();

  // Search drivers
  Future<List<EmployeeModel>> searchDrivers({
    String search = '',
    String employerId = '',
  }) async {
    try {
      print('DriverService: Searching drivers with query: $search');

      final queryParams = <String, dynamic>{};
      if (search.isNotEmpty) queryParams['search'] = search;
      if (employerId.isNotEmpty) queryParams['employerId'] = employerId;

      final response = await dio.get(
        '/api/drivers',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> driversData = response.data;
        print('DriverService: Found ${driversData.length} drivers');

        return driversData.map((data) => EmployeeModel.fromJson(data)).toList();
      }

      return [];
    } catch (e) {
      print('DriverService: Error searching drivers: $e');
      return [];
    }
  }

  // Get driver by ID
  Future<EmployeeModel?> getDriverById(String driverId) async {
    try {
      print('DriverService: Fetching driver: $driverId');
      final response = await dio.get('/api/drivers/$driverId');

      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('DriverService: Error fetching driver: $e');
      return null;
    }
  }
}
