import 'package:flutter/material.dart';

class RateHistoryItem {
  final String date;
  final int totalSalesKg;
  final int ratePerKg;

  RateHistoryItem({
    required this.date,
    required this.totalSalesKg,
    required this.ratePerKg,
  });
}

class RateProvider extends ChangeNotifier {
  int _todayRate = 264;
  String _searchQuery = '';
  String _selectedMonth = '';
  String _selectedRate = '';
  
  // Sample rate history data
  final List<RateHistoryItem> _rateHistory = [
    RateHistoryItem(
      date: "2023-10-01",
      totalSalesKg: 1200,
      ratePerKg: 264,
    ),
    RateHistoryItem(
      date: "2023-09-28",
      totalSalesKg: 950,
      ratePerKg: 260,
    ),
    RateHistoryItem(
      date: "2023-09-25",
      totalSalesKg: 1100,
      ratePerKg: 260,
    ),
    RateHistoryItem(
      date: "2023-09-20",
      totalSalesKg: 800,
      ratePerKg: 250,
    ),
    RateHistoryItem(
      date: "2023-09-15",
      totalSalesKg: 1300,
      ratePerKg: 250,
    ),
    RateHistoryItem(
      date: "2023-09-10",
      totalSalesKg: 1050,
      ratePerKg: 250,
    ),
    RateHistoryItem(
      date: "2023-09-05",
      totalSalesKg: 900,
      ratePerKg: 200,
    ),
  ];

  // Getters
  int get todayRate => _todayRate;
  String get searchQuery => _searchQuery;
  String get selectedMonth => _selectedMonth;
  String get selectedRate => _selectedRate;
  List<RateHistoryItem> get rateHistory => _rateHistory;
  
  List<RateHistoryItem> get filteredHistory {
    List<RateHistoryItem> filtered = List.from(_rateHistory);
    
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.date.contains(_searchQuery) ||
            item.totalSalesKg.toString().contains(_searchQuery) ||
            item.ratePerKg.toString().contains(_searchQuery);
      }).toList();
    }
    
    if (_selectedMonth.isNotEmpty) {
      filtered = filtered.where((item) {
        return item.date.contains(_selectedMonth);
      }).toList();
    }
    
    if (_selectedRate.isNotEmpty) {
      final rate = int.tryParse(_selectedRate);
      if (rate != null) {
        filtered = filtered.where((item) {
          return item.ratePerKg == rate;
        }).toList();
      }
    }
    
    return filtered;
  }

  // Setters
  void setTodayRate(int rate) {
    _todayRate = rate;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedMonth(String month) {
    _selectedMonth = month;
    notifyListeners();
  }

  void setSelectedRate(String rate) {
    _selectedRate = rate;
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedMonth = '';
    _selectedRate = '';
    notifyListeners();
  }
}