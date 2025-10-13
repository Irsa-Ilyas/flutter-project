import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';
// Removed unused CustomSvgIcon import
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class RateHistoryListWidget extends StatelessWidget {
  const RateHistoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RateProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Total Sales (KG)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Rate per KG",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        Column(
          children: provider.filteredHistory.map((item) {
            return Container(
              padding: const EdgeInsets.only(top: 6, bottom: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.date,
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${item.totalSalesKg} KG",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "PKR ${item.ratePerKg}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (provider.searchQuery.isNotEmpty ||
            provider.selectedMonth.isNotEmpty ||
            provider.selectedRate.isNotEmpty)
          Center(
            child: CustomButtonWidget(
              type: ButtonType.full,
              text: "Clear Filters",
              icon: AppIcons.clear,
              backgroundColor: Colors.grey[300]!,
              textColor: Colors.black87,
              onPressed: () => provider.clearFilters(),
            ),
          ),
      ],
    );
  }
}