import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_text_field_widget.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/widgets/plant_card.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/widgets/order_card.dart';
import 'package:tracklet_pro/src/view/screens/distributor/dashboard/components/widgets/requested_item.dart';
import 'package:tracklet_pro/src/shared_widgets/order_status_widget.dart';
import 'package:tracklet_pro/src/shared_widgets/section_header_widget.dart';
import 'package:tracklet_pro/src/model/dashboard_summary.dart' as model;
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/providers/plant_provider.dart';

class DistributorDashboardScreen extends StatefulWidget {
  const DistributorDashboardScreen({super.key});

  @override
  State<DistributorDashboardScreen> createState() =>
      _DistributorDashboardScreenState();
}

class _DistributorDashboardScreenState
    extends State<DistributorDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch plants when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final plantProvider = context.read<PlantProvider>();
        plantProvider.fetchPlants();
      } catch (e) {
        print('Error fetching plants: $e');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFieldWidget(
                  hint: AppStrings.search,
                  suffixIcon: Icon(Icons.search),
                  onChanged: (value) {},
                ),
                const SizedBox(height: 14),
                SectionHeaderWidget(title: "Top Plants", onSeeAll: () {}),
                _buildTopPlantsSection(),
                const SizedBox(height: 14),
                SectionHeaderWidget(title: "Previous Orders", onSeeAll: () {}),
                _buildPreviousOrdersSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method to update summary data from API
  void updateSummaryData(List<model.DashboardSummary> summaries) {
    // This method will be implemented when API integration is added
  }

  // Placeholder for loading dashboard data from API
  Future<void> loadDashboardData() async {
    // This method will be implemented when API integration is added
  }

  Widget _buildTopPlantsSection() {
    return Consumer<PlantProvider>(
      builder: (context, plantProvider, _) {
        if (plantProvider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final plants = plantProvider.activePlants;

        if (plants.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('No plants available')),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: plants.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  return PlantCard(
                    imageUrl: plant.imageUrl,
                    name: plant.name,
                    price: plant.perKgPrice,
                    plantId: plant.id ?? '',
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPreviousOrdersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            OrderCard(
              plantName: 'Tracklet.CO Gas Plant',
              driverName: 'Romail Ahmed',
              instructions:
                  'Please deliver after 2 PM. Handle cylinders carefully.',
              requestedItems: [
                RequestedItem(weight: 45.4, quantity: 3),
                RequestedItem(weight: 15, quantity: 5),
              ],
              totalKg: 225,
              status: OrderStatus.inProgress,
            ),
            const SizedBox(height: 12),
            OrderCard(
              plantName: 'Arham Traders',
              driverName: 'Romail Ahmed',
              instructions: '',
              requestedItems: [],
              totalKg: 0,
              status: OrderStatus.completed,
            ),
          ],
        ),
      ],
    );
  }
}
