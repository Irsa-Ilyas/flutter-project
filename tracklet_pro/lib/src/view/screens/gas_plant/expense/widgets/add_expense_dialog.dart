import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/expense/providers/expense_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/model/expense_model.dart';

class AddExpenseDialog extends StatelessWidget {
  const AddExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddExpenseDialogContent();
  }
}

class _AddExpenseDialogContent extends StatefulWidget {
  const _AddExpenseDialogContent();

  @override
  State<_AddExpenseDialogContent> createState() =>
      _AddExpenseDialogContentState();
}

class _AddExpenseDialogContentState extends State<_AddExpenseDialogContent> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = ExpenseCategories.other;
  String _selectedPaymentMethod = PaymentMethods.cash;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime firstDate = DateTime(today.year - 1);
    final DateTime lastDate = DateTime(today.year + 1);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.darkBlue,
              onPrimary: AppColors.onBackground,
              onSurface: AppColors.onBackground,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.darkBlue),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      CustomFlushbar.showError(context, message: 'Please select a date');
      return;
    }

    if (!mounted) return;

    try {
      final expenseProvider = Provider.of<ExpenseProvider>(
        context,
        listen: false,
      );
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final userId = authProvider.user?.id;
      if (userId == null) {
        CustomFlushbar.showError(context, message: 'User not logged in');
        return;
      }

      final success = await expenseProvider.addExpense(
        userId: userId,
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text.trim()),
        category: _selectedCategory,
        date: _selectedDate!,
        description: _descriptionController.text.trim(),
        paymentMethod: _selectedPaymentMethod,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
        CustomFlushbar.showSuccess(
          context,
          message: 'Expense added successfully',
        );
      } else {
        CustomFlushbar.showError(
          context,
          message: expenseProvider.errorMessage ?? 'Failed to add expense',
        );
      }
    } catch (e) {
      if (!mounted) return;
      CustomFlushbar.showError(context, message: 'Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 20),

                // Expense Title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (Rs)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value.trim()) <= 0) {
                      return 'Amount must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  items: ExpenseCategories.all.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Payment Method Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  items: PaymentMethods.all.map((method) {
                    return DropdownMenuItem(value: method, child: Text(method));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Date Picker
                InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightBlue),
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.lightBlue.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(
                            color: _selectedDate == null
                                ? AppColors.disabledTextColor
                                : AppColors.onBackground,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_today,
                          color: AppColors.darkBlue,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Description (Optional)
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Consumer<ExpenseProvider>(
                  builder: (context, provider, _) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: provider.isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButtonWidget(
                            text: 'Save',
                            isLoading: provider.isLoading,
                            onPressed: provider.isLoading
                                ? () {}
                                : _saveExpense,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
