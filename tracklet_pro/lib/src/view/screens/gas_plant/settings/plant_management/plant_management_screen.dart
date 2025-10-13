import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/plant_provider.dart';
import 'package:tracklet_pro/src/utils/index.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/plant_management/widgets/plant_form_dialog.dart';

class PlantManagementScreen extends StatefulWidget {
  const PlantManagementScreen({super.key});

  @override
  State<PlantManagementScreen> createState() => _PlantManagementScreenState();
}

class _PlantManagementScreenState extends State<PlantManagementScreen> {
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
      appBar: AppBar(
        backgroundColor: AppColors.lightBlueBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onBackground),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Manage Plants',
          style: TextStyle(color: AppColors.onBackground),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPlantForm(context),
        backgroundColor: AppColors.darkBlue,
        label: const Text('Add Plant'),
        icon: const Icon(Icons.add),
      ),
      body: Consumer<PlantProvider>(
        builder: (context, plantProvider, _) {
          if (plantProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final plants = plantProvider.activePlants;

          if (plants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.factory_outlined,
                    size: 100,
                    color: AppColors.disabledTextColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No plants added yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.disabledTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to add your first plant',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.disabledTextColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => plantProvider.refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: plants.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final plant = plants[index];
                return _PlantCard(
                  plant: plant,
                  onEdit: () => _showPlantForm(context, plant: plant),
                  onDelete: () => _confirmDelete(context, plant.id!),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showPlantForm(BuildContext context, {plant}) {
    showDialog(
      context: context,
      builder: (context) => PlantFormDialog(plant: plant),
    );
  }

  void _confirmDelete(BuildContext context, String plantId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plant'),
        content: const Text('Are you sure you want to delete this plant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final plantProvider = context.read<PlantProvider>();
              final success = await plantProvider.deletePlant(plantId);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Plant deleted successfully'
                          : 'Failed to delete plant',
                    ),
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _PlantCard extends StatelessWidget {
  final plant;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlantCard({
    required this.plant,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.onBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              plant.imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  color: AppColors.lightBlue,
                  child: const Icon(
                    Icons.factory,
                    color: AppColors.disabledTextColor,
                    size: 50,
                  ),
                );
              },
            ),
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plant.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkBlue,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.darkBlue),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(
                  icon: Icons.location_on,
                  text: '${plant.location}, ${plant.city}',
                ),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.phone, text: plant.contactNumber),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.email, text: plant.email),
                const SizedBox(height: 4),
                _InfoRow(
                  icon: Icons.attach_money,
                  text: 'Per KG Price: Rs. ${plant.perKgPrice}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.disabledTextColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: AppColors.onBackground),
          ),
        ),
      ],
    );
  }
}
