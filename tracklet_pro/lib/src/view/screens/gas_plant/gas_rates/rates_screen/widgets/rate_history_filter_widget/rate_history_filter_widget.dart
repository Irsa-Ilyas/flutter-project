import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/providers/rate_provider.dart';

class RateHistoryFilterWidget extends StatelessWidget {
  const RateHistoryFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RateProvider>();

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.start,
            decoration: const InputDecoration(
              hintText: "Search by date, sales, or rate",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            style: const TextStyle(color: Colors.black87, fontSize: 14),
            onChanged: (value) => provider.setSearchQuery(value),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            isExpanded: true,
            hint: const Text(
              "Month",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            dropdownColor: Colors.white,
            initialValue: provider.selectedMonth.isEmpty
                ? null
                : provider.selectedMonth,
            items: ["Sep", "Oct", "Nov", "Dec"]
                .map(
                  (month) => DropdownMenuItem(
                    value: month,
                    child: Text(
                      month,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => provider.setSelectedMonth(value ?? ''),
          ),
        ),
        const SizedBox(width: 6),
        // Rate dropdown - smaller
        Expanded(
          flex: 1,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            isExpanded: true,
            hint: const Text(
              "Rates",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            style: const TextStyle(fontSize: 12, color: Colors.black87),
            dropdownColor: Colors.white,
            initialValue: provider.selectedRate.isEmpty
                ? null
                : provider.selectedRate,
            items: ["200", "250", "260", "264"]
                .map(
                  (rate) => DropdownMenuItem(
                    value: rate,
                    child: Text(
                      rate,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => provider.setSelectedRate(value ?? ''),
          ),
        ),
      ],
    );
  }
}
