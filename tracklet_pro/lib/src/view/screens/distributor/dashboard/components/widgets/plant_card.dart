import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/screens/request_screen/request_screen.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class PlantCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int price;
  final String plantId;

  const PlantCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.plantId = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.lightBlueBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image Section
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: Image.network(
              imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 80,
                  width: double.infinity,
                  color: AppColors.lightBlue,
                  child: Icon(
                    Icons.image,
                    color: AppColors.disabledTextColor,
                    size: 40,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          // Plant Details
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 8),

          // Price
          Text(
            'Per KG Price: $price',
            style: const TextStyle(color: AppColors.onBackground, fontSize: 12),
          ),
          SizedBox(height: 8),

          // Order Button
          CustomButtonWidget(
            type: ButtonType.full,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DistributorRequestScreen(
                    plantName: name,
                    plantImageUrl: imageUrl,
                    plantId: plantId.isNotEmpty
                        ? plantId
                        : '68ea8119d66e64e12947e12b', // Default Gas Plant ID
                  ),
                ),
              );
            },
            text: AppStrings.orderNow, // Using AppStrings
          ),
        ],
      ),
    );
  }
}
