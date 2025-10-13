import 'package:tracklet_pro/src/service/base_service.dart';
import 'package:tracklet_pro/src/model/expense_model.dart';

class ExpenseService extends BaseService {
  // Singleton instance
  static final ExpenseService _instance = ExpenseService._internal();
  factory ExpenseService() => _instance;
  ExpenseService._internal();

  // Get all expenses for a user
  Future<List<ExpenseModel>> getUserExpenses(String userId) async {
    try {
      print('ExpenseService: Fetching expenses for userId: $userId');
      final response = await dio.get('/api/expenses/user/$userId');
      print('ExpenseService: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> expensesData = response.data;
        print('ExpenseService: Found ${expensesData.length} expenses');

        final expenses = expensesData
            .map((expenseData) => ExpenseModel.fromJson(expenseData))
            .toList();

        return expenses;
      }

      return [];
    } catch (e) {
      print('ExpenseService: Error fetching expenses: $e');
      return [];
    }
  }

  // Get single expense by ID
  Future<ExpenseModel?> getExpenseById(String expenseId) async {
    try {
      print('ExpenseService: Fetching expense with ID: $expenseId');
      final response = await dio.get('/api/expenses/$expenseId');

      if (response.statusCode == 200) {
        return ExpenseModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('ExpenseService: Error fetching expense: $e');
      return null;
    }
  }

  // Create new expense
  Future<ExpenseModel?> createExpense({
    required String title,
    required double amount,
    required String category,
    required DateTime date,
    required String userId,
    String description = '',
    String paymentMethod = 'Cash',
    String plantId = '',
  }) async {
    try {
      print('ExpenseService: Creating expense: $title');

      final expenseData = {
        'title': title,
        'amount': amount,
        'category': category,
        'date': date.toIso8601String(),
        'description': description,
        'paymentMethod': paymentMethod,
        'userId': userId,
        'plantId': plantId,
      };

      final response = await dio.post('/api/expenses', data: expenseData);
      print('ExpenseService: Expense created with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ExpenseModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('ExpenseService: Error creating expense: $e');
      rethrow;
    }
  }

  // Update expense
  Future<ExpenseModel?> updateExpense({
    required String expenseId,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? description,
    String? paymentMethod,
  }) async {
    try {
      print('ExpenseService: Updating expense: $expenseId');

      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (amount != null) updateData['amount'] = amount;
      if (category != null) updateData['category'] = category;
      if (date != null) updateData['date'] = date.toIso8601String();
      if (description != null) updateData['description'] = description;
      if (paymentMethod != null) updateData['paymentMethod'] = paymentMethod;

      final response = await dio.put('/api/expenses/$expenseId', data: updateData);
      print('ExpenseService: Expense updated with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return ExpenseModel.fromJson(response.data);
      }

      return null;
    } catch (e) {
      print('ExpenseService: Error updating expense: $e');
      rethrow;
    }
  }

  // Delete expense
  Future<bool> deleteExpense(String expenseId) async {
    try {
      print('ExpenseService: Deleting expense: $expenseId');
      final response = await dio.delete('/api/expenses/$expenseId');
      print('ExpenseService: Expense deleted with status: ${response.statusCode}');

      return response.statusCode == 200;
    } catch (e) {
      print('ExpenseService: Error deleting expense: $e');
      return false;
    }
  }

  // Get expense statistics
  Future<Map<String, dynamic>?> getExpenseStats(String userId) async {
    try {
      print('ExpenseService: Fetching expense stats for userId: $userId');
      final response = await dio.get('/api/expenses/user/$userId/stats');

      if (response.statusCode == 200) {
        print('ExpenseService: Stats received');
        return response.data as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      print('ExpenseService: Error fetching expense stats: $e');
      return null;
    }
  }
}

