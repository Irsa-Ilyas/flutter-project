import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/expense_model.dart';
import 'package:tracklet_pro/src/service/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();

  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<ExpenseModel> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get total expenses
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get expenses by category
  Map<String, double> get expensesByCategory {
    final Map<String, double> categoryTotals = {};

    for (final expense in _expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    return categoryTotals;
  }

  // Get this month's expenses
  List<ExpenseModel> get thisMonthExpenses {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);

    return _expenses.where((expense) {
      return expense.date.isAfter(firstDayOfMonth) ||
          expense.date.isAtSameMomentAs(firstDayOfMonth);
    }).toList();
  }

  // Get this month's total
  double get thisMonthTotal {
    return thisMonthExpenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }

  // Fetch all expenses for a user
  Future<void> fetchExpenses(String userId) async {
    print('ExpenseProvider: Fetching expenses for userId: $userId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _expenses = await _expenseService.getUserExpenses(userId);
      print('ExpenseProvider: Fetched ${_expenses.length} expenses');
      _errorMessage = null;
    } catch (e) {
      print('ExpenseProvider: Error fetching expenses: $e');
      _errorMessage = 'Failed to fetch expenses';
      _expenses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new expense
  Future<bool> addExpense({
    required String userId,
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    String description = '',
    String paymentMethod = 'Cash',
    String plantId = '',
  }) async {
    print('ExpenseProvider: Adding expense: $title');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final expense = await _expenseService.createExpense(
        title: title,
        amount: amount,
        category: category,
        date: date,
        userId: userId,
        description: description,
        paymentMethod: paymentMethod,
        plantId: plantId,
      );

      if (expense != null) {
        _expenses.add(expense);
        _expenses.sort((a, b) => b.date.compareTo(a.date)); // Sort by date
        print('ExpenseProvider: Expense added successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to add expense';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('ExpenseProvider: Error adding expense: $e');
      _errorMessage = 'Failed to add expense: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update an expense
  Future<bool> updateExpense({
    required String expenseId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    String? paymentMethod,
  }) async {
    print('ExpenseProvider: Updating expense: $expenseId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedExpense = await _expenseService.updateExpense(
        expenseId: expenseId,
        title: title,
        amount: amount,
        category: category,
        date: date,
        description: description,
        paymentMethod: paymentMethod,
      );

      if (updatedExpense != null) {
        // Update in local list
        final index = _expenses.indexWhere((e) => e.id == expenseId);
        if (index != -1) {
          _expenses[index] = updatedExpense;
          _expenses.sort((a, b) => b.date.compareTo(a.date)); // Re-sort
        }
        print('ExpenseProvider: Expense updated successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to update expense';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('ExpenseProvider: Error updating expense: $e');
      _errorMessage = 'Failed to update expense: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete an expense
  Future<bool> deleteExpense(String expenseId) async {
    print('ExpenseProvider: Deleting expense: $expenseId');
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _expenseService.deleteExpense(expenseId);

      if (success) {
        _expenses.removeWhere((e) => e.id == expenseId);
        print('ExpenseProvider: Expense deleted successfully');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _errorMessage = 'Failed to delete expense';
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('ExpenseProvider: Error deleting expense: $e');
      _errorMessage = 'Failed to delete expense: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Refresh expenses
  Future<void> refresh(String userId) async {
    await fetchExpenses(userId);
  }
}
