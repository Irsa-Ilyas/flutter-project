import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/tank_card.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';

class TankList extends StatelessWidget {
  const TankList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, stockProvider, _) {
        if (stockProvider.isLoading && stockProvider.tanks.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (stockProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stockProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                CustomButtonWidget(
                  type: ButtonType.full,
                  text: "Retry",
                  onPressed: () {
                    final authProvider = context.read<AuthProvider>();
                    final ownerId = authProvider.user?.id;
                    if (ownerId != null) {
                      stockProvider.fetchTanks(ownerId);
                    }
                  },
                ),
              ],
            ),
          );
        }

        if (stockProvider.tanks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  "No tanks available",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tap 'Add Tank' to create your first tank",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: stockProvider.tanks.length,
          separatorBuilder: (context, _) => const Divider(thickness: 1, height: 20),
          itemBuilder: (context, index) {
            final tank = stockProvider.tanks[index];
            return TankCard(tank: tank);
          },
        );
      },
    );
  }
}
