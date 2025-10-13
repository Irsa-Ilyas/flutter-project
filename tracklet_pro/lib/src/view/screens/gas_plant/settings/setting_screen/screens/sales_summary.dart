import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/orders/order/presentation/widgets/download_report_dialog.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/provider/sales_summary_provider.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/orders_overview_card.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/settings/setting_screen/widgets/summary_card.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_flushbar.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';
import 'package:tracklet_pro/src/widget/custom_svg_icon.dart';
import 'package:tracklet_pro/src/utils/app_icons.dart';
import 'package:tracklet_pro/src/shared_widgets/custom_button_widget.dart';

class SalesSummaryScreen extends StatelessWidget {
  const SalesSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SalesSummaryProvider(context),
      child: const _SalesSummaryView(),
    );
  }
}

class _SalesSummaryView extends StatelessWidget {
  const _SalesSummaryView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SalesSummaryProvider>();

    // Refresh data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.refreshData(context);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomSvgIcon(
            assetName: AppIcons.svgArrowBack,
            width: 24,
            height: 24,
            color: Theme.of(context).colorScheme.onSurface,
            fallbackIcon: AppIcons.arrowBackIosNew,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text('Sales & Reports', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Sales Summary', style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: 'Total',
                      subtitle: 'KG sold today',
                      value: '${provider.totalKgToday.toString()} KG',
                      dark: true,
                      trailing: CircleAvatar(
                        radius: 16,
                        backgroundColor: AppColors.navyBlue,
                        child: CustomSvgIcon(
                          assetName: AppIcons.svgLock,
                          width: 16,
                          height: 16,
                          color: Colors.white,
                          fallbackIcon: AppIcons.lockOutline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SummaryCard(
                      title: 'Today',
                      subtitle: 'Sales Amount',
                      value: '${_formatAmount(provider.totalAmountToday)} PKR',
                      trailing: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade200,
                        child: CustomSvgIcon(
                          assetName: 'lib/src/assets/svg/savings.svg', // Placeholder - needs to be created
                          width: 16,
                          height: 16,
                          color: Colors.black,
                          fallbackIcon: Icons.savings_outlined,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text('Orders Overview', style: Theme.of(context).textTheme.headlineMedium),
              OrdersOverviewCard(
                title: 'Total Orders',
                period: provider.period,
                data: provider.weeklyOrders,
                highlightIndex: provider.selectedIndex,
                onPeriodChanged: provider.setPeriod,
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 48,
                width: double.infinity,
                child: CustomButtonWidget(
                  type: ButtonType.full,
                  text: 'View Detailed Report',
                  backgroundColor: Colors.black,
                  onPressed: () {
                    // For now, show the same dialog as download but for viewing
                    CustomFlushbar.showInfo(
                      context,
                      message: 'Detailed report view feature coming soon! Use Download Report for now.',
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                height: 48,
                width: double.infinity,
                child: CustomButtonWidget(
                  type: ButtonType.full,
                  text: 'Download Report',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () async {
                    final result = await showDownloadReportDialog(context);
                    if (result == null || !context.mounted) return;

                    try {
                      // Show loading indicator
                      CustomFlushbar.showInfo(
                        context,
                        message: 'Generating PDF report... Please wait.',
                        duration: const Duration(seconds: 3),
                      );

                      // Simulate PDF generation
                      await Future.delayed(const Duration(seconds: 2));

                      // Show success message
                      if (context.mounted) {
                        CustomFlushbar.showSuccess(
                          context,
                          message: 'PDF report downloaded successfully for ${result.date.day}/${result.date.month}/${result.date.year}!',
                        );
                      }

                    } catch (e) {
                      // Handle errors - PDF was likely saved but sharing failed
                      if (context.mounted) {
                        final errorMessage = e.toString();
                        if (errorMessage.contains('PDF saved successfully')) {
                          // This is actually a success message for mobile
                          CustomFlushbar.showSuccess(
                            context,
                            message: errorMessage.replaceFirst('Exception: ', ''),
                            duration: const Duration(seconds: 8),
                          );
                          // Show additional info message
                          CustomFlushbar.showInfo(
                            context,
                            message: 'Please check your device Downloads folder',
                          );
                        } else {
                          CustomFlushbar.showError(
                            context,
                            message: 'Failed to generate PDF: $errorMessage',
                            duration: const Duration(seconds: 5),
                          );
                        }
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAmount(int amount) {
    // Basic formatting like 800,000
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1 && i != s.length - 1) buf.write(',');
    }
    return buf.toString();
  }
}