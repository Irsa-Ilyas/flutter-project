import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/employee_model.dart';

class EmployeeService extends BaseService {
  // Singleton instance
  static final EmployeeService _instance = EmployeeService._internal();
  factory EmployeeService() => _instance;
  EmployeeService._internal();

  // Get all employees for an employer
  Future<List<EmployeeModel>> getEmployerEmployees(String employerId) async {
    try {
      print('EmployeeService: Fetching employees for employerId: $employerId');
      final response = await dio.get('/api/employees/employer/$employerId');
      print('EmployeeService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> employeesData = response.data;
        print('EmployeeService: Found ${employeesData.length} employees');

        final employees = employeesData
            .map((employeeData) => EmployeeModel.fromJson(employeeData))
            .toList();

        return employees;
      }

      return [];
    } catch (e) {
      print('EmployeeService: Error fetching employees: $e');
      return [];
    }
  }

  // Get single employee by ID
  Future<EmployeeModel?> getEmployeeById(String employeeId) async {
    try {
      print('EmployeeService: Fetching employee with ID: $employeeId');
      final response = await dio.get('/api/employees/$employeeId');

      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('EmployeeService: Error fetching employee: $e');
      return null;
    }
  }

  // Create new employee
  Future<EmployeeModel?> createEmployee({
    required String name,
    required String email,
    required String phoneNumber,
    required String employerId,
    String role = 'Worker',
    String licenseNumber = '',
    String address = '',
    double salary = 0,
    DateTime? dateOfJoining,
    String status = 'Active',
    String vehicleNumber = '',
    String profileImageUrl = '',
  }) async {
    try {
      print('EmployeeService: Creating employee: $name');

      final employeeData = {
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'licenseNumber': licenseNumber,
        'address': address,
        'salary': salary,
        'dateOfJoining': (dateOfJoining ?? DateTime.now()).toIso8601String(),
        'status': status,
        'employerId': employerId,
        'vehicleNumber': vehicleNumber,
        'profileImageUrl': profileImageUrl,
      };

      final response = await dio.post('/api/employees', data: employeeData);
      print(
        'EmployeeService: Employee created with status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('EmployeeService: Error creating employee: $e');
      rethrow;
    }
  }

  // Update employee
  Future<EmployeeModel?> updateEmployee({
    required String employeeId,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    String? licenseNumber,
    String? address,
    double? salary,
    DateTime? dateOfJoining,
    String? status,
    String? vehicleNumber,
    String? profileImageUrl,
  }) async {
    try {
      print('EmployeeService: Updating employee: $employeeId');

      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (role != null) updateData['role'] = role;
      if (licenseNumber != null) updateData['licenseNumber'] = licenseNumber;
      if (address != null) updateData['address'] = address;
      if (salary != null) updateData['salary'] = salary;
      if (dateOfJoining != null) {
        updateData['dateOfJoining'] = dateOfJoining.toIso8601String();
      }
      if (status != null) updateData['status'] = status;
      if (vehicleNumber != null) updateData['vehicleNumber'] = vehicleNumber;
      if (profileImageUrl != null) {
        updateData['profileImageUrl'] = profileImageUrl;
      }

      final response = await dio.put(
        '/api/employees/$employeeId',
        data: updateData,
      );
      print(
        'EmployeeService: Employee updated with status: ${response.statusCode}',
      );

      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('EmployeeService: Error updating employee: $e');
      rethrow;
    }
  }

  // Delete employee
  Future<bool> deleteEmployee(String employeeId) async {
    try {
      print('EmployeeService: Deleting employee: $employeeId');
      final response = await dio.delete('/api/employees/$employeeId');
      print(
        'EmployeeService: Employee deleted with status: ${response.statusCode}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('EmployeeService: Error deleting employee: $e');
      return false;
    }
  }

  // Get employee statistics
  Future<Map<String, dynamic>?> getEmployeeStats(String employerId) async {
    try {
      print(
        'EmployeeService: Fetching employee stats for employerId: $employerId',
      );
      final response = await dio.get(
        '/api/employees/employer/$employerId/stats',
      );

      if (response.statusCode == 200) {
        print('EmployeeService: Stats received');
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('EmployeeService: Error fetching employee stats: $e');
      return null;
    }
  }
}
