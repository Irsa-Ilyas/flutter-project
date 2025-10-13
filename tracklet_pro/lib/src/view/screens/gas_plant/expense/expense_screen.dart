import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/providers/expense_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/widgets/add_expense_dialog.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/widgets/expense_list_item.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class GasPlantExpenseScreen extends StatefulWidget {
  const GasPlantExpenseScreen({super.key});

  @override
  State<GasPlantExpenseScreen> createState() => _GasPlantExpenseScreenState();
}

class _GasPlantExpenseScreenState extends State<GasPlantExpenseScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch expenses when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final authProvider = context.read<AuthProvider>();
        final expenseProvider = context.read<ExpenseProvider>();
        final userId = authProvider.user?.id;

        if (userId != null) {
          expenseProvider.fetchExpenses(userId);
        }
      } catch (e) {
        Logger.error('Error fetching expenses: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(user?.name ?? 'Expense'),
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.lightBlueBackground,
      ),
      body: Column(
        children: [
          // Header row with title and download button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Expense',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                CustomButtonWidget(
                  type: ButtonType.small,
                  text: 'Download Expense',
                  onPressed: () {
                    CustomFlushbar.showInfo(
                      context,
                      message: 'Downloading expense report...',
                    );
                  },
                ),
              ],
            ),
          ),
          // Expenses list
          Expanded(
            child: Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, child) {
                if (expenseProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (expenseProvider.expenses.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No expenses added yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to add your first expense',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final userId = authProvider.user?.id;
                    if (userId != null) {
                      await expenseProvider.refresh(userId);
                    }
                  },
                  child: ListView.builder(
                    itemCount: expenseProvider.expenses.length,
                    itemBuilder: (context, index) {
                      return ExpenseListItem(
                        expense: expenseProvider.expenses[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenseDialog();
            },
          );
        },
        backgroundColor: const Color(0xFF002455),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}