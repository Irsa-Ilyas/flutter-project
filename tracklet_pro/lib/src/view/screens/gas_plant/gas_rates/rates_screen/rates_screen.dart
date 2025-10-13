import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/rates_screen/widgets/rate_history_filter_widget/rate_history_filter_widget.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/rates_screen/widgets/rate_history_list_widget/rate_history_list_widget.dart';
import 'package:tracklet_pro/src/view/screens/gas_plant/gas_rates/rates_screen/widgets/today_rates_widget/today_rates_widget.dart';
import 'package:tracklet_pro/src/utils/index.dart';

class RatesScreen extends StatelessWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Rates'),
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.lightBlueBackground,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 8),
              TodayRateWidget(),
              SizedBox(height: 24),
              Text(
                "Rate History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              RateHistoryFilterWidget(),
              SizedBox(height: 16),
              RateHistoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}