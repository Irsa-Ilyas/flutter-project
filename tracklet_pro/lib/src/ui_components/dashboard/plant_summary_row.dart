import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/model/tab_config.dart';
import 'package:tracklet_pro/src/ui_components/dashboard/summary_tab_widget.dart';
import 'package:tracklet_pro/src/model/dashboard_summary.dart';

class PlantSummaryRow extends StatelessWidget {
  final List<TabConfig> tabs;
  final List<DashboardSummary>? summaryData;
  final List<bool> selectedTabs;
  final Function(int)? onTabSelected;

  const PlantSummaryRow({
    super.key,
    this.tabs = const [],
    this.summaryData,
    this.selectedTabs = const [false, false, false],
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    // If we have summary data from API, use that
    if (summaryData != null && summaryData!.isNotEmpty) {
      return _buildFromSummaryData();
    }
    
    // Otherwise, use the static tab config data
    if (tabs.isNotEmpty) {
      return _buildFromTabConfig();
    }
    
    // Default empty state
    return const SizedBox.shrink();
  }

  Widget _buildFromSummaryData() {
    return Row(
      children: List.generate(summaryData!.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < summaryData!.length - 1 ? 8 : 0),
            child: SummaryTab.fromSummaryData(
              summary: summaryData![index],
              isSelected: selectedTabs.length > index ? selectedTabs[index] : false,
              onTap: onTabSelected != null ? () => onTabSelected!(index) : () {},
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFromTabConfig() {
    return Row(
      children: List.generate(tabs.length, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < tabs.length - 1 ? 8 : 0),
            child: SummaryTab(
              value: tabs[index].value,
              label: tabs[index].label,
              iconPath: tabs[index].iconPath,
              color: tabs[index].color,
              isSelected: selectedTabs.length > index ? selectedTabs[index] : false,
              onTap: tabs[index].onTap,
              headerTop: tabs[index].headerTop,
              headerBottom: tabs[index].headerBottom,
            ),
          ),
        );
      }),
    );
  }
}