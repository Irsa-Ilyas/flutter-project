import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

class AddTankDialog extends StatefulWidget {
  const AddTankDialog({super.key});

  @override
  State<AddTankDialog> createState() => _AddTankDialogState();
}

class _AddTankDialogState extends State<AddTankDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _capacityController = TextEditingController();
  final _initialGasController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _initialGasController.dispose();
    super.dispose();
  }

  Future<void> _saveTank() async {
    if (!_formKey.currentState!.validate()) return;

    if (!mounted) return;

    try {
      final stockProvider = Provider.of<StockProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final ownerId = authProvider.user?.id;
      if (ownerId == null) {
        CustomFlushbar.showError(context, message: 'User not logged in');
        return;
      }

      final success = await stockProvider.addTank(
        name: _nameController.text.trim(),
        ownerId: ownerId,
        totalCapacity: double.parse(_capacityController.text.trim()),
        location: _locationController.text.trim(),
        available: _initialGasController.text.trim().isNotEmpty
            ? double.parse(_initialGasController.text.trim())
            : 0,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
        CustomFlushbar.showSuccess(
          context,
          message: 'Tank added successfully',
        );
      } else {
        CustomFlushbar.showError(
          context,
          message: stockProvider.errorMessage ?? 'Failed to add tank',
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
                const Text(
                  'Add Tank',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.onBackground,
                  ),
                ),
                const SizedBox(height: 20),

                // Tank Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Tank Name *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter tank name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Location
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Location (Optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(height: 16),

                // Total Capacity
                TextFormField(
                  controller: _capacityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total Capacity (Tons) *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter capacity';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value.trim()) <= 0) {
                      return 'Capacity must be greater than 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Initial Gas (Optional)
                TextFormField(
                  controller: _initialGasController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Initial Gas (Tons) - Optional',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                  ),
                  validator: (value) {
                    if (value != null && value.trim().isNotEmpty) {
                      if (double.tryParse(value.trim()) == null) {
                        return 'Please enter a valid number';
                      }
                      final gas = double.parse(value.trim());
                      if (gas < 0) {
                        return 'Gas cannot be negative';
                      }
                      if (_capacityController.text.isNotEmpty) {
                        final capacity = double.parse(_capacityController.text.trim());
                        if (gas > capacity) {
                          return 'Gas cannot exceed capacity';
                        }
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Buttons
                Consumer<StockProvider>(
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
                            text: 'Add',
                            isLoading: provider.isLoading,
                            onPressed: provider.isLoading ? () {} : _saveTank,
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

