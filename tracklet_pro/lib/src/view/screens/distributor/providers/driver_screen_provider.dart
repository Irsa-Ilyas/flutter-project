import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view_model/base_view_model.dart';
import 'package:tracklet_pro/src/model/driver_model.dart';

// Driver screen provider - yeh provider driver screen ke liye data manage krta hai
class DriverScreenProvider extends BaseViewModel {
  List<DriverModel> _drivers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  
  // Mock data - yeh mock data hai real app mein API se aayega
  final List<DriverModel> _mockDrivers = [
    DriverModel(
      id: '1',
      name: 'Ahmed Khan',
      status: 'Available',
      description: '5 years experience, 250 deliveries completed',
      showAvatar: true,
      rating: 4.8,
      deliveries: 250,
    ),
    DriverModel(
      id: '2',
      name: 'Usman Ali',
      status: 'On Delivery',
      description: '3 years experience, 180 deliveries completed',
      showAvatar: true,
      rating: 4.6,
      deliveries: 180,
    ),
    DriverModel(
      id: '3',
      name: 'Hassan Raza',
      status: 'Available',
      description: '4 years experience, 320 deliveries completed',
      showAvatar: true,
      rating: 4.9,
      deliveries: 320,
    ),
    DriverModel(
      id: '4',
      name: 'Ali Mustafa',
      status: 'Offline',
      description: '2 years experience, 95 deliveries completed',
      showAvatar: true,
      rating: 4.3,
      deliveries: 95,
    ),
  ];
  
  // Getters
  List<DriverModel> get drivers => _drivers;
  @override
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;
  
  TextEditingController searchController = TextEditingController();
  
  // Filtered drivers based on search query
  List<DriverModel> get filteredDrivers {
    if (_searchQuery.isEmpty) {
      return _drivers;
    }
    return _drivers.where((driver) {
      final name = driver.name.toLowerCase();
      final status = driver.status.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || status.contains(query);
    }).toList();
  }
  
  // Constructor
  DriverScreenProvider() {
    searchController.addListener(_onSearchChanged);
    loadDrivers();
  }
  
  // Search change listener
  void _onSearchChanged() {
    _searchQuery = searchController.text;
    notifyListeners();
  }
  
  // Load drivers - yeh method drivers load krta hai API se
  Future<void> loadDrivers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      _drivers = List.from(_mockDrivers);
      // In real implementation, it would be:
      // final response = await ApiService.getDrivers();
      // _drivers = response.map((json) => DriverModel.fromJson(json)).toList();
    } catch (e) {
      _error = 'Failed to load drivers';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Refresh drivers - yeh method drivers refresh krta hai
  Future<void> refreshDrivers() async {
    await loadDrivers();
  }
  
  // Add new driver - yeh method naya driver add krta hai
  Future<bool> addDriver(DriverModel driver) async {
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      _drivers.add(driver);
      notifyListeners();
      return true;
      // In real implementation, it would be:
      // final response = await ApiService.addDriver(driver.toJson());
      // if (response.success) {
      //   _drivers.add(driver);
      //   notifyListeners();
      //   return true;
      // }
      // return false;
    } catch (e) {
      _error = 'Failed to add driver';
      return false;
    }
  }
  
  // Update driver - yeh method driver update krta hai
  Future<bool> updateDriver(DriverModel driver) async {
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      final index = _drivers.indexWhere((d) => d.id == driver.id);
      if (index != -1) {
        _drivers[index] = driver;
        notifyListeners();
        return true;
      }
      return false;
      // In real implementation, it would be:
      // final response = await ApiService.updateDriver(driver.id, driver.toJson());
      // if (response.success) {
      //   final index = _drivers.indexWhere((d) => d.id == driver.id);
      //   if (index != -1) {
      //     _drivers[index] = driver;
      //     notifyListeners();
      //     return true;
      //   }
      // }
      // return false;
    } catch (e) {
      _error = 'Failed to update driver';
      return false;
    }
  }
  
  // Delete driver - yeh method driver delete krta hai
  Future<bool> deleteDriver(String driverId) async {
    _error = null;
    notifyListeners();
    
    try {
      // Simulate API call - yeh jagah real API call aayega
      await Future.delayed(const Duration(seconds: 1));
      _drivers.removeWhere((driver) => driver.id == driverId);
      notifyListeners();
      return true;
      // In real implementation, it would be:
      // final response = await ApiService.deleteDriver(driverId);
      // if (response.success) {
      //   _drivers.removeWhere((driver) => driver.id == driverId);
      //   notifyListeners();
      //   return true;
      // }
      // return false;
    } catch (e) {
      _error = 'Failed to delete driver';
      return false;
    }
  }
  
  // Dispose
  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}