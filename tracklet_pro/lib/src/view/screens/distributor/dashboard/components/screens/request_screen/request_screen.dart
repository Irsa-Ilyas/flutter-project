import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/distributor/providers/distributor_request_view_model.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/screens/quantity_selector/quantity_selector.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_text_field_widget.dart';

// Distributor request screen - yeh screen distributor ke liye request bhejne ke liye hai
class DistributorRequestScreen extends StatelessWidget {
  final String plantName;
  final String plantImageUrl;
  final String plantId;

  const DistributorRequestScreen({
    super.key,
    required this.plantName,
    required this.plantImageUrl,
    this.plantId = '68ea8119d66e64e12947e12b', // Use actual Gas Plant user ID
  });

  // Submit request function - yeh function request submit krta hai
  Future<void> _submitRequest(
    BuildContext context,
    DistributorRequestViewModel provider,
    AuthProvider authProvider,
  ) async {
    provider.clearMessages();
    final success = await provider.submitRequest(
      plantName: plantName,
      plantImageUrl: plantImageUrl,
      specialInstructions: provider.specialInstructions,
      distributorId: authProvider.user?.id ?? 'distributor_123',
      distributorName: authProvider.user?.name ?? 'Unknown Distributor',
      plantId: plantId, // Pass plantId
    );

    if (success) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text(AppStrings.requestSubmitted),
          content: Text(AppStrings.requestSubmittedSuccessfully),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppStrings.ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DistributorRequestViewModel>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant image - yeh plant ki image dikhata hai
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: Image.network(
                plantImageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  width: double.infinity,
                  color: AppColors.lightBlue,
                  child: Icon(Icons.image, color: AppColors.disabledTextColor),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plantName,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppStrings.priceKG}:${provider.perKgPrice}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.darkBlue),
                  ),
                  const SizedBox(height: 12),

                  // Quantity selectors - yeh quantity select krne ke liye hai
                  Text(
                    AppStrings.selectQuantity,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ...provider.cylinderWeights.map(
                    (w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1.0),
                      child: QuantitySelector(weight: w.toInt()),
                    ),
                  ),
                  const Divider(),

                  // Summary - yeh total aur discount dikhata hai
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.total,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text('${provider.totalKg} ${AppStrings.kg}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.discount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      DropdownButton<int>(
                        value: provider.discount,
                        items: [
                          DropdownMenuItem(
                            value: 0,
                            child: Text(AppStrings.none),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text(AppStrings.pkr2),
                          ),
                          DropdownMenuItem(
                            value: 5,
                            child: Text(AppStrings.pkr5),
                          ),
                        ],
                        onChanged: (val) => provider.setDiscount(val ?? 0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${AppStrings.total} ${AppStrings.price}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${provider.totalPrice.toStringAsFixed(0)} ${AppStrings.pkr}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Text(
                    AppStrings.specialInstructions,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  CustomTextFieldWidget(
                    controller: TextEditingController(
                      text: provider.specialInstructions,
                    ),
                    maxLines: 2,
                    onChanged: (value) =>
                        provider.setSpecialInstructions(value),
                    hint: AppStrings.deliveryInstructions,
                  ),
                  const SizedBox(height: 12),

                  // Messages - yeh error ya success messages dikhata hai
                  if (provider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.error.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),

                  // Submit button - yeh request submit krne ke liye hai
                  SizedBox(
                    width: double.infinity,
                    child: CustomButtonWidget(
                      type: ButtonType.full,
                      onPressed: provider.isSubmitting
                          ? () {}
                          : () =>
                                _submitRequest(context, provider, authProvider),
                      text: provider.isSubmitting
                          ? AppStrings.submitting
                          : AppStrings.requestCylinder,
                      isLoading: provider.isSubmitting,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
