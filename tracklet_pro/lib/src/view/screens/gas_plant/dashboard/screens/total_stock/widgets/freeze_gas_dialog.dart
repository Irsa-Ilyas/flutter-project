import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/model/tank_model.dart';

class FreezeGasDialog extends StatefulWidget {
  final TankModel tank;

  const FreezeGasDialog({super.key, required this.tank});

  @override
  State<FreezeGasDialog> createState() => _FreezeGasDialogState();
}

class _FreezeGasDialogState extends State<FreezeGasDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _freezeGas() async {
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

      final amount = double.parse(_amountController.text.trim());

      final success = await stockProvider.freezeGasInTank(
        tankId: widget.tank.id!,
        amount: amount,
        ownerId: ownerId,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop();
        CustomFlushbar.showSuccess(
          context,
          message: 'Gas frozen successfully in ${widget.tank.name}',
        );
      } else {
        CustomFlushbar.showError(
          context,
          message: stockProvider.errorMessage ?? 'Failed to freeze gas',
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
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.ac_unit, color: AppColors.darkBlue),
                  const SizedBox(width: 8),
                  Text(
                    'Freeze Gas in ${widget.tank.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onBackground,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tank Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Available Gas',
                      '${widget.tank.available.toStringAsFixed(1)} Tons',
                    ),
                    _buildInfoRow(
                      'Already Frozen',
                      '${widget.tank.freezeGas.toStringAsFixed(1)} Tons',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount to Freeze (Tons) *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                    fillColor: AppColors.lightBlue.withValues(alpha: 0.1),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value.trim()) == null) {
                    return 'Please enter a valid number';
                  }
                  final amount = double.parse(value.trim());
                  if (amount <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  if (amount > widget.tank.available) {
                    return 'Not enough available gas';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Info message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Frozen gas will not be used for orders',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Buttons
              Consumer<StockProvider>(
                builder: (context, provider, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: provider.isFreezingGas
                              ? null
                              : () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomButtonWidget(
                          text: 'Freeze',
                          isLoading: provider.isFreezingGas,
                          onPressed: provider.isFreezingGas ? () {} : _freezeGas,
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
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.darkBlue),
          ),
        ],
      ),
    );
  }
}

