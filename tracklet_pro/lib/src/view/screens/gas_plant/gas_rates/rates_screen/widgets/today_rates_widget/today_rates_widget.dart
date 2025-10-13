import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';

class TodayRateWidget extends StatelessWidget {
  const TodayRateWidget({super.key});

  void _showUpdateRateDialog(BuildContext context) {
    final provider = context.read<RateProvider>();
    final controller = TextEditingController(
      text: provider.todayRate.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Rate'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter new rate per KG:'),
              const SizedBox(height: 16),
              TextFormField(
                controller: controller,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  suffixText: "PKR",
                  labelText: "Rate per KG",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                autofocus: true,
                // Removed validator since Validators class is not available
              ),
            ],
          ),
          actions: [
            CustomButtonWidget(
              type: ButtonType.tab,
              text: 'Cancel',
              backgroundColor: Colors.transparent,
              textColor: Theme.of(context).colorScheme.onSurface,
              onPressed: () => Navigator.pop(context),
            ),
            CustomButtonWidget(
              type: ButtonType.full,
              text: 'Update',
              backgroundColor: Colors.blue[900],
              onPressed: () {
                final newRate = int.tryParse(controller.text);
                if (newRate != null && newRate > 0) {
                  provider.setTodayRate(newRate);
                  Navigator.pop(context);
                  CustomFlushbar.showSuccess(
                    context,
                    message: "Rate updated to PKR $newRate successfully!",
                  );
                } else {
                  CustomFlushbar.showError(
                    context,
                    message: "Please enter a valid positive rate",
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RateProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today Rate per KG:",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Text(
              "PKR ${provider.todayRate.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: CustomButtonWidget(
                text: "Update Rate",
                onPressed: () => _showUpdateRateDialog(context),
                type: ButtonType.full,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
