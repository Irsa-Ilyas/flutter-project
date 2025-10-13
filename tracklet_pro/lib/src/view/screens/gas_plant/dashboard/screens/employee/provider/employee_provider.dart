import 'package:flutter/foundation.dart';
import 'package:tracklet_pro/src/model/employee_model.dart';

class EmployeeProvider extends ChangeNotifier {
  // Sample employee data - in a real app this would come from an API
  final List<EmployeeModel> _employees = [
    EmployeeModel(
      name: 'Ahmed Khan',
      email: 'ahmed@tracklet.com',
      phoneNumber: '+92 300 1234567',
      employerId: 'default',
      role: 'Driver',
      status: 'Active',
    ),
    EmployeeModel(
      name: 'Sana Ali',
      email: 'sana@tracklet.com',
      phoneNumber: '+92 301 2345678',
      employerId: 'default',
      role: 'Manager',
      status: 'Active',
    ),
    EmployeeModel(
      name: 'Usman Siddiqui',
      email: 'usman@tracklet.com',
      phoneNumber: '+92 302 3456789',
      employerId: 'default',
      role: 'Supervisor',
      status: 'On Leave',
    ),
    EmployeeModel(
      name: 'Fatima Zara',
      email: 'fatima@tracklet.com',
      phoneNumber: '+92 303 4567890',
      employerId: 'default',
      role: 'Worker',
      status: 'Inactive',
    ),
  ];

  List<EmployeeModel> get employees => _employees;

  // Method to get employees by status
  List<EmployeeModel> getEmployeesByStatus(String status) {
    return _employees
        .where((employee) => employee.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  // Method to get active employees
  List<EmployeeModel> get activeEmployees {
    return _employees
        .where((employee) => employee.status.toLowerCase() == 'active')
        .toList();
  }

  // Method to add a new employee
  void addEmployee(EmployeeModel employee) {
    _employees.add(employee);
    notifyListeners();
  }

  // Method to update an employee
  void updateEmployee(EmployeeModel updatedEmployee, int index) {
    if (index >= 0 && index < _employees.length) {
      _employees[index] = updatedEmployee;
      notifyListeners();
    }
  }

  // Method to remove an employee
  void removeEmployee(int index) {
    if (index >= 0 && index < _employees.length) {
      _employees.removeAt(index);
      notifyListeners();
    }
  }
}
