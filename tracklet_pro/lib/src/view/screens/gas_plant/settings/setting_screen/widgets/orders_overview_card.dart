import 'package:flutter/material.dart';

class OrdersOverviewCard extends StatelessWidget {
  final String title;
  final String period;
  final List<int> data;
  final int highlightIndex;
  final ValueChanged<String> onPeriodChanged;
  const OrdersOverviewCard({
    super.key,
    required this.title,
    required this.period,
    required this.data,
    required this.highlightIndex,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labels = const ['MON','TUE','WED','THU','FRI','SAT','SUN'];
    final maxY = (data.isEmpty ? 0 : data.reduce((a,b) => a > b ? a : b)).toDouble() + 10;
    final yTicks = const [60, 50, 40, 30];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600) ?? const TextStyle(fontWeight: FontWeight.w600)),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: period,
                  items: const [
                    DropdownMenuItem(value: 'Weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'Monthly', child: Text('Monthly')),
                    DropdownMenuItem(value: 'Yearly', child: Text('Yearly')),
                  ],
                  onChanged: (v) => v == null ? null : onPeriodChanged(v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-axis labels
                SizedBox(
                  width: 28,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: yTicks
                        .map((v) => Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                v.toString(),
                                style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 10) ?? TextStyle(fontSize: 10, color: scheme.onSurface.withValues(alpha: 0.6)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(width: 8),

                // Chart area with grid + bars
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          // Grid lines
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                yTicks.length,
                                (index) => Container(
                                  height: 1,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                            ),
                          ),
                          // Bars
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (int i = 0; i < data.length; i++) ...[
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (i == highlightIndex)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: scheme.primary,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              data[i].toString(),
                                              style: TextStyle(color: scheme.onPrimary, fontSize: 10, fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        Flexible(
                                          child: Container(
                                            width: 16,
                                            height: maxY == 0 ? 0 : (data[i] / maxY) * 120,
                                            decoration: BoxDecoration(
                                              color: i == highlightIndex ? scheme.primary : scheme.primary.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(labels[i], style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withValues(alpha: 0.6), fontSize: 10) ?? TextStyle(fontSize: 10, color: scheme.onSurface.withValues(alpha: 0.6))),
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
