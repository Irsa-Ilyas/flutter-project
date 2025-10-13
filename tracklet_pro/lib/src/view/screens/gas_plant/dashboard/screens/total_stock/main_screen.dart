import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/stock_provider.dart';
import 'package:tracklet_pro/src/providers/auth_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/summary_cards.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/tank_list.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/dashboard/screens/total_stock/widgets/add_tank_dialog.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class TotalStockScreen extends StatefulWidget {
  const TotalStockScreen({super.key});

  @override
  State<TotalStockScreen> createState() => _TotalStockScreenState();
}

class _TotalStockScreenState extends State<TotalStockScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tanks when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final authProvider = context.read<AuthProvider>();
        final stockProvider = context.read<StockProvider>();
        final ownerId = authProvider.user?.id;

        if (ownerId != null) {
          stockProvider.fetchTanks(ownerId);
          stockProvider.fetchStats(ownerId);
        }
      } catch (e) {
        Logger.error('Error fetching tanks: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(user?.name ?? "Total Stock"),
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.lightBlueBackground,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<StockProvider>(
        builder: (context, stockProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              final ownerId = authProvider.user?.id;
              if (ownerId != null) {
                await stockProvider.refresh(ownerId);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "Tanks Status Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  CustomButtonWidget(
                    type: ButtonType.full,
                    text: "Download Report",
                    icon: Icons.download,
                    backgroundColor: const Color(0xffF0F4F8),
                    textColor: const Color(0xFF0D2B58),
                    onPressed: stockProvider.isLoading
                        ? () {}
                        : () {
                            CustomFlushbar.showInfo(
                              context,
                              message: 'Report download feature coming soon!',
                            );
                          },
                  ),
                  const SizedBox(height: 18),
                  const SummaryCards(),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: CustomButtonWidget(
                      type: ButtonType.full,
                      text: "Add Tank",
                      backgroundColor: const Color(0xFF0D2B58),
                      onPressed: stockProvider.isLoading
                          ? () {}
                          : () {
                              _showAddTankDialog(context);
                            },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    "View available gas in tanks",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Expanded(
                    child: TankList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddTankDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTankDialog(),
    );
  }
}